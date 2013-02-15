# lib/mithril/parsers/parser_helpers.rb

require 'mithril/parsers'

module Mithril::Parsers
  module ParserHelpers
    def preprocess_input(text)
      text.
        gsub(/[\"?!\-',.:\(\)\[\]\;]/, ' ').
        gsub(/(\s+)/, ' ').strip
    end # method preprocess_input
    
    def wordify(text)
      text.split(/\s+/)
    end # method wordify
  end # module
end # module
