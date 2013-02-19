# lib/mithril/controllers/abstract_controller.rb

require 'mithril/controllers'
require 'mithril/controllers/mixins/commands_base'
require 'mithril/controllers/mixins/mixin_with_actions'
require 'mithril/parsers/simple_parser'

module Mithril::Controllers
  # Base class for Mithril controllers. Extending controller functionality
  # can be implemented either through direct class inheritance, e.g.
  # 
  #   ModuleController > ProxyController > AbstractController
  # 
  # or through mixing in shared functionality with a Mixin, but all controllers
  # ought to extend AbstractController unless you have a very compelling reason
  # otherwise.
  class AbstractController
    extend Mithril::Controllers::Mixins::MixinWithActions
    
    mixin Mithril::Controllers::Mixins::CommandsBase
    
    # @param [Mithril::Request] request Request object containing the volatile
    #   state information needed to build the controller and execute commands.
    # @raise [ArgumentError] If request does not respond to :session.
    def initialize(request)
      unless request.respond_to? :session
        raise ArgumentError.new "expected request to respond_to :session" 
      end # unless
      
      @request = request
    end # constructor
    
    # Internal helper for identifying a class in a log statement.
    def class_name
      klass = self.class
      while klass.name.nil?
        klass = klass.superclass
      end # while
      klass.name.split("::").last
    end # accessor class_name
    private :class_name
    
    #########################
    ### Executing Actions ###
    
    # The parser object used to process input into a command and an arguments
    # object.
    def parser
      @parser ||= Mithril::Parsers::SimpleParser.new(self)
    end # method parser
    
    # Delegates to the parser instance. Note that if a custom parser is used
    # that does not conform to the expected API, the return values may be
    # different than listed.
    # @param [Object] input The input to be parsed.
    # @return [Array] The first element will be the matched command, or nil if
    #   no command was found. The second element will be the arguments object
    #   created by the parser.
    def parse_command(input)
      self.parser.parse_command input
    end # method parse_command
    
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
    
    # Default output when a command cannot be found for a given input.
    # @param [Object] input The input that failed to match a command.
    # @return [Object]
    def command_missing(input)
      "I'm sorry, I don't know how to \"#{input.to_s}\". Please try another" +
        " command, or enter \"help\" for assistance."
    end # method command_missing
    
    # Parses input into a command and arguments, then matches the command to an
    # available action (if any), invokes the action, and returns the result. If
    # there is no matching command, but the controller has an empty action :""
    # defined and allow_empty_action? evaluates to true, the controller will
    # instead invoke the empty action with the parsed arguments. If no matching
    # command is found, returns the result of command_missing.
    # 
    # @param [Object] input The input to be parsed and evaluated. Type and
    #   format will depend on the parser used.
    # @return [Object] The result of the command. If no command is found,
    #   returns the result of command_missing.
    # @see #allow_empty_action?
    # @see #command_missing
    # @see #parse_command
    def invoke_command(text)
      # Mithril.logger.debug "#{class_name}.invoke_command(), text =" +
      #   " #{text.inspect}"
      
      command, args = self.parse_command text
      
      if self.has_action? command
        self.invoke_action command, args
      elsif allow_empty_action?
        self.invoke_action :"", args
      else
        command_missing(text)
      end # unless-elsif
    end # method invoke_command
    
    # If this method evaluates to true, if the controller does not recognize an
    # action from the input text, it will attempt to invoke the empty action
    # :"" with the full arguments list.
    def allow_empty_action?
      false
    end # method allow_empty_action?
  end # class AbstractController
end # module
