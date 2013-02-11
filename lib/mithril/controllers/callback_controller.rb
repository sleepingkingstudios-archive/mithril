# lib/mithril/controllers/callback_controller.rb

require 'mithril/controllers/abstract_controller'
require 'mithril/controllers/mixins/callback_helpers'
require 'mithril/controllers/mixins/help_actions'

module Mithril::Controllers
  class CallbackController < AbstractController
    mixin Mixins::CallbackHelpers
    mixin Mixins::HelpActions
    
    def initialize(request)
      super
      
      return unless self.has_callbacks?(request.session)
      
      @callbacks = self.deserialize_callbacks request.session[callback_key]
    end # method initialize
    
    def callbacks
      @callbacks
    end # method callbacks
    
    def actions(allow_private = false)
      actions = super
      actions = actions.dup.update(callbacks) unless callbacks.nil?
      actions
    end # method actions
    
    def invoke_action(command, arguments, allow_private = false)
      return super if @callbacks.nil? || (callback = @callbacks[command]).nil?
      
      controller = callback[:controller].new request
      action     = callback[:action]
      
      clear_callbacks(request.session)
      @callbacks = nil
      
      controller.invoke_action(action, arguments, true)
    end # method invoke_action
  end # class CallbackController
end # module
