# spec/mithril/parsers/parser_helpers_spec.rb

require 'mithril/spec_helper'
require 'mithril/parsers/parser_helpers_helper'

require 'mithril/parsers/parser_helpers'

describe Mithril::Parsers::ParserHelpers do
  let :described_class do Class.new.send :include, super(); end
  let :instance do described_class.new; end
  
  it_behaves_like Mithril::Parsers::ParserHelpers
end # describe
