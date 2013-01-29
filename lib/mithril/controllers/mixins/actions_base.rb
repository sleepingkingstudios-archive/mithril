# lib/mithril/controllers/mixins/actions_base.rb

require 'mithril/controllers/mixins/action_mixin'

module Mithril::Controllers::Mixins
  # Core functions for implementing a command+args response model. ActionsBase
  # should be mixed in to controllers, either directly or via an intermediate
  # Mixin that implements default or shared actions.
  # 
  # @see Mithril::Mixin
  # @see Mithril::Controllers::Mixins::ActionsBase::ClassMethods
  module ActionsBase
    extend Mithril::Controllers::Mixins::ActionMixin
    
    # These methods get extended into the class of the controller through the
    # magic of Mixin.
    # 
    # @see Mithril::Mixin
    # @see Mithril::Controllers::Mixins::ActionsBase
    module ClassMethods
      # Defines an action to which the controller will respond.
      # 
      # @param [Symbol, String] key Best practice is to use snake_case,
      #   e.g. all lower-case letters, with words separated by underscores. It
      #   *ought* to work anyway, but caveat lector.
      # @param [Hash] params Optional. Expects a hash of configuration values.
      # @option params [Boolean] :private If set to true, creates a private
      #     action. Private actions are not listed by "help" and cannot be
      #     invoked directly by the user. They can be used to set up internal
      #     APIs.
      # @yieldparam [Hash] session An object describing the current (volatile)
      #   state of the user session.
      # @yieldparam [Object] arguments Additional information from the request
      #   to be passed into the action. Using the default parser, the arguments
      #   object will be an Array, but other parsers may pass in other data
      #   structures.
      def define_action(key, params = {}, &block)
        key = key.to_s.downcase.gsub(/\s+|\-+/,'_').intern
        
        define_method :"action_#{key}", &block
        
        @actions ||= {}
        @actions[key] = params
      end # class method define_action
      
      # Lists the actions defined for the current controller by its base class.
      # In almost all cases, the actions instance method should be used
      # instead, as it handles class-based inheritance.
      # 
      # @param [Boolean] allow_private If true, will include private actions.
      # @return [Hash] The actions defined on the current controller class.
      # 
      # @see Mithril::Controllers::Mixins::ActionsBase#actions
      def actions(allow_private = false)
        actions = @actions ||= {}
        
        unless allow_private
          actions = actions.select { |key, action| !action.has_key? :private }
        end # unless
        
        actions
      end # class method actions
    end # module ClassMethods
    
    # @return [Mithril::Request]
    attr_reader :request
    
    # Lists the actions available to the current controller.
    # 
    # @param [Boolean] allow_private If true, will include private actions.
    # @return [Hash] The actions available to this controller.
    def actions(allow_private = false)
      actions = {}
      
      actions.update(self.class.superclass.actions(allow_private)) if (klass = self.class.superclass).respond_to? :actions
      
      actions.update(self.class.actions(allow_private))
      
      actions
    end # method actions
    
    # @param [Symbol, String] key The action key to be checked.
    # @param [Boolean] allow_private If true, will include private actions.
    # @return [Boolean] True if the action is available on this controller with
    #   the specified private setting; false otherwise.
    def has_action?(key, allow_private = false)
      return false if key.nil?
      
      self.actions(allow_private).has_key? key.intern
    end # method has_action?
    
    # Searches for a matching action. If found, calls the action with the given
    # session hash and arguments list.
    # 
    # @param [Symbol, String] command Converted to a string. The converted
    #   string must be an exact match (===) to the key passed in to
    #   klass.define_action.
    # @param [Object] arguments Additional information from the request to be
    #   passed into the action. Using the default parser, the arguments object
    #   will be an Array, but other parsers may pass in other data structures.
    # @param [Boolean] allow_private If true, can invoke private actions.
    # 
    # @return [String, nil] The result of the action (should be a string), or
    #   nil if no action was invoked.
    def invoke_action(command, arguments, allow_private = false)
      session = request ? request.session || {} : {}
      if self.has_action? command, allow_private
        self.send :"action_#{command}", session, arguments
      else
        nil
      end # if-else
    end # method invoke_action
  end # module ActionsBase
end # module
