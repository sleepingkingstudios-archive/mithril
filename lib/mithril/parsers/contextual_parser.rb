# lib/mithril/parsers/contextual_parser.rb

require 'mithril/parsers'
require 'mithril/parsers/simple_parser'

module Mithril::Parsers
  class ContextualParser < SimpleParser
    def initialize(actions)
      super
      
      @keywords = {
        "and"   => :reverse_lookup,
        "at"    => :target,
        "on"    => :target,
        "to"    => :receiver,
        "using" => :combination,
        "with"  => :combination,
      } # end keywords
    end # constructor
    
    def parse_command(text)
      command, args = super
      
      return command, process_arguments(args)
    end # method parse_command
    
    # Takes an input array of string arguments for a command and performs a
    # basic context analysis using the parser's defined keywords. The arguments
    # are divided by keyword according to the pattern [text [KEYWORD text]*].
    # For each keyword, the following text is re-joined and inserted into a
    # results hash based on the value of the keyword.
    # 
    # @param [Array<String>] words The arguments to be processed.
    # @return [Hash<Symbol => Array<String>>] The processed arguments.
    # @see #keywords
    def process_arguments(words)
      keyword = nil
      results = {}
      
      word_buffer = []
      
      words.each do |word|
        if @keywords.include? word
          (results[keyword] ||= []) << word_buffer.join(" ") unless word_buffer.empty?
          word_buffer.clear
          
          keyword = @keywords[word] unless @keywords[word] == :reverse_lookup
        else
          word_buffer << word
        end # if
      end # each
      
      (results[keyword] ||= []) << word_buffer.join(" ") unless word_buffer.empty?
      
      results
    end # method process_arguments
    
    attr_accessor :keywords
  end # class
end # module
