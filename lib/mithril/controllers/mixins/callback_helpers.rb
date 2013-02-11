# lib/mithril/controllers/mixins/callback_helpers.rb

require 'mithril/controllers/abstract_controller'
require 'mithril/controllers/mixins/mixin_with_actions'
require 'mithril/errors/callback_error'

module Mithril::Controllers::Mixins
  module CallbackHelpers
    extend MixinWithActions
    
    include Mithril::Errors
    
    # Helper method for determining whether or not an object is a valid
    # controller class.
    # 
    # @param [Object] controller The object to test.
    # @return [Boolean] True if the object is a class extending
    #   AbstractController; otherwise false.
    def controller?(ctr)
      ctr.is_a?(Class) && ctr <= Mithril::Controllers::AbstractController
    end # method controller
    
    # The namespaces to check for controller classes when deserializing
    # callbacks. Namespaces can be appended using standard Array methods.
    # Defaults to ["Mithril::Controllers"].
    # 
    # @example Appending a namespace.
    #   namespaces << "MyModule::Controllers"
    # @return [Array<String>]
    def namespaces
      @namespaces ||= %w(Mithril::Controllers)
    end # method namespaces
    
    # Helper method for resolving a controller class from a name string. Each
    # namespace is checked in order. If the namespace corresponds to a module
    # and the module has a controller with the given name (and sub-module path,
    # if applicable), it returns that controller.
    # 
    # @see #namespaces
    # @return [AbstractController, nil]
    def resolve_controller(path) # :nodoc:
      return nil if path.nil? || 0 == path.length
      
      segments = path.split(':')
      
      namespaces.each do |namespace|
        segments = (namespace.split(":") + path.split(":"))
        segments.delete("")
        
        ns = Kernel
        segments.each_with_index do |segment, index|
          segment = segment.intern
          next unless ns.const_defined? segment
          
          if segments.count == index + 1
            controller = ns.const_get segment
            return controller if controller?(controller)
          else
            ns = ns.const_get segment
          end # if
        end # segments
      end # each
      
      nil
    end # method resolve_controller
    
    def callback_key
      :callbacks
    end # method callback_key
    private :callback_key
    
    # Abstracts the details of retrieving the serialized callback from the
    # session object.
    # 
    # @param [Hash] session The session object.
    def get_callbacks(session)
      return nil if session.nil?
      session[callback_key]
    end # method get_callbacks
    
    # Abstracts the details of storing the serialized callback in the session
    # object.
    # 
    # @param [Hash] session The session object.
    def set_callbacks(session, callback)
      return if session.nil?
      session[callback_key] = callback
    end # method set_callbacks
    
    # Abstracts the details of removing a stored callback from the session
    # object.
    # 
    # @param [Hash] session The session object.
    def clear_callbacks(session)
      session.delete callback_key
    end # method clear_callbacks
    
    # Returns true if there is a stored callback in the session object;
    # otherwise returns false.
    # 
    # @param [Hash] session The session object.
    def has_callbacks?(session)
      session.has_key? callback_key
    end # method has_callbacks?
    
    # Sets up a callback, parsing the given parameters into a hash of strings
    # that should be safe for storing in a session. If anything goes wrong with
    # parsing the hash, should raise a CallbackError.
    # 
    # @param [Hash<String => Hash>] callbacks Each key should be a string or
    #   symbol, and each value should be a child hash with the following keys:
    #   * controller [AbstractController] Expects a Class extending
    #     AbstractController.
    #   * action [String, Symbol] If this callback is selected, the
    #     CallbackController will attempt to invoke the specified action on the
    #     specified controller with the remaining arguments from the user's
    #     input.
    # @return [Hash<String => String>] A sanitized version of the callbacks
    #   hash that should be safe for serialization.
    # @raise CallbackError
    #   * "empty callbacks hash": When supplied with a callbacks argument that
    #     is either nil or empty.
    #   * "malformed callbacks hash": When supplied with a callbacks argument
    #     that is malformed. The specific errors can be accessed via the
    #     CallbackError errors method. To ease debugging, on finding a
    #     malformed callbacks hash, the method still iterates through the
    #     callbacks to identify all broken values, not just the first one it
    #     finds.
    # @see #deserialize_callbacks
    def serialize_callbacks(callbacks)
      if callbacks.nil? || callbacks.empty?
        raise CallbackError.new "empty callbacks hash"
      end # if
      
      config, exception = {}, nil
      callbacks.each do |callback, params|
        controller = params[:controller]
        if controller.nil?
          exception ||= CallbackError.new "malformed callbacks hash"
          (exception.errors[callback] ||= []) << "expected controller not to be nil"
        elsif !controller?(controller)
          exception ||= CallbackError.new "malformed callbacks hash"
          (exception.errors[callback] ||= []) << "expected controller to extend AbstractController"
        end # if
        
        action = params[:action]
        if action.nil?
          exception ||= CallbackError.new "malformed callbacks hash"
          (exception.errors[callback] ||= []) << "expected action not to be nil"
        end # if
        
        next unless exception.nil?
        
        ctr_string = controller.name
        namespaces.each do |namespace|
          if ctr_string =~ /^#{namespace}::/
            ctr_string.gsub!(/^#{namespace}::/,'')
            break
          end # if
        end # namespaces
        
        config[callback.to_s] = "#{ctr_string},#{action}"
      end # each
      
      if exception.nil?
        return config
      else
        raise exception
      end # if-else
    end # method serialize_callbacks
    
    # Extracts interned callback names, controller classes, and action keys
    # from a serialized callbacks object.
    # 
    # @param [Hash] params The serialized callbacks to unpack. Each key should
    #   be a String, and each value should be a comma-separated string with the
    #   following values (in order):
    #   * controller [String] The name of a class extending AbstractController,
    #     or the path to such a controller including one or more module names
    #     and the controller name, separated by "::".
    #   * action [String] The action to invoke on the target controller.
    # @return [Hash<Symbol => Hash>] See #serialize_callbacks.
    # @raise CallbackError
    #   * "empty callbacks hash": When supplied with a session that is nil, or
    #     with a session[:callback] hash that is nil or empty.
    #   * "malformed callbacks hash": When supplied with a session[:callback]
    #     hash that is malformed. The specific errors can be accessed via the
    #     CallbackError errors method.
    # @see #resolve_controller
    # @see #serialize_callbacks
    def deserialize_callbacks(params)
      if params.nil? || params.empty?
        raise CallbackError.new "empty callbacks hash"
      end # if
      
      callbacks, exception = {}, nil
      params.each do |key, value|
        callback = key.to_s
        if key.nil? || callback.empty?
          exception ||= CallbackError.new "malformed callbacks hash"
          (exception.errors[callback] ||= []) << "expected callback not to be nil"
          next
        end # if
        
        segments = value.split ","
        
        ctr_string = segments.shift
        controller = self.resolve_controller ctr_string
        
        if controller.nil?
          exception ||= CallbackError.new "malformed callbacks hash"
          (exception.errors[callback] ||= []) << "expected controller to extend AbstractController"
        end # if
        
        action = segments.shift
        if action.nil? || action.empty?
          exception ||= CallbackError.new "malformed callbacks hash"
          (exception.errors[callback] ||= []) << "expected action not to be nil"
        end # if
        
        next unless exception.nil?
        
        callback_key = callback.gsub(/\s+/,'_').intern
        callbacks[callback_key] = { :controller => controller, :action => action.intern }
      end # each
      
      raise exception unless exception.nil?
      
      callbacks
    end # method deserialize_callback
  end # module
end # module
