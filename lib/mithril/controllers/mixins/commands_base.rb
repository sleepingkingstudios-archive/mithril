# lib/mithril/controllers/mixins/commands_base.rb

require 'mithril/controllers/mixins/actions_base'

module Mithril::Controllers::Mixins
  module CommandsBase
    extend MixinWithActions
    
    mixin ActionsBase
    
    # @return [Array] All commands available to this controller.
    def commands
      actions.keys.map do |key| key.to_s.gsub '_', ' '; end
    end # method commands
    
    # @param [String, Symbol] text The command to check. The parameter is
    #   converted to a String, and must exactly match a command available
    #   to the controller.
    # @return [Boolean] True if this controller has the specified command.
    #   Otherwise false.
    # @see #can_invoke?
    def has_command?(text)
      commands.include? text.to_s
    end # method has_command?
    
    # @example Using :has_command? and :can_invoke?
    #   # With an action "do" defined
    #   has_command?("do something") #=> false
    #   can_invoke?("do something")  #=> true
    # @param [Object] input The sample input to be parsed. Type and format will
    #   depend on the parser used.
    # @return [Boolean] True if this controller has a command matching the
    #   provided input. Otherwise false.
    # @see #has_command?
    def can_invoke?(input)
      self.allow_empty_action? || !self.parse_command(input).first.nil?
    end # method can_invoke?
  end # module
end # module
