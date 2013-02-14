# lib/mithril/errors/action_error.rb

require 'mithril/errors'

module Mithril::Errors
  # Raised to indicate an error condition during an invoked action.
  class ActionError < StandardError
    def initialize(message, controller, action, session, arguments)
      super(message)
      
      @controller = controller
      @action     = action
      @session    = session
      @arguments  = arguments
    end # method initialize
    
    attr_reader :action, :arguments, :controller, :session
  end # class ActionError
end # module
