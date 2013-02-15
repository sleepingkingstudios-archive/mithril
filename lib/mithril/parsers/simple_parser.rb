# lib/mithril/parsers/simple_parser.rb

require 'mithril/parsers'
require 'mithril/parsers/parser_helpers'

module Mithril::Parsers
  class SimpleParser
    include ParserHelpers
    
    def initialize(actions)
      @actions = actions
    end # method initialize
    
    # Takes a string input and separates into words, then identifies a matching
    # action (if any) and remaining arguments. Returns both the command and the
    # arguments array, so usage can be as follows:
    # 
    # @example With a "say" command:
    #   command, args = parse_command("say Greetings programs!")
    #     #=> command = :say, args = ["greetings", "programs"]
    # @example With no "hello" command:
    #   command, args = parse_command("Hello world")
    #     #=> command = nil, args = ["hello", "world"]
    # 
    # @param [String] text Expects a string composed of one or more words,
    #   separated by whitespace or hyphens.
    # @return [Array] A two-element array consisting of the command and an
    #   array of the remaining text arguments (if any), or [nil, args] if no
    #   matching action was found.
    def parse_command(text)
      words = wordify preprocess_input text
      
      key  = nil
      args = []
      
      while 0 < words.count
        key = words.join('_').downcase.intern
        
        return key, args if @actions.has_action? key
        
        args.unshift words.pop
      end # while
      
      return nil, args
    end # method parse_command
  end # class
end # module
