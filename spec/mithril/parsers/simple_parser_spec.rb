# spec/mithril/parsers/simple_parser_spec.rb

require 'mithril/spec_helper'
require 'mithril/parsers/parser_helpers_helper'

require 'mithril/controllers/mixins/actions_base'
require 'mithril/parsers/simple_parser'

describe Mithril::Parsers::SimpleParser do
  describe :initialize do
    specify { expect(described_class).to construct.with(1).arguments }
  end # describe
  
  let :actions_source do
    Object.new.tap do |obj| obj.stub :has_action? do false; end; end
  end # let
  let :instance do described_class.new actions_source; end
  
  it_behaves_like Mithril::Parsers::ParserHelpers
  
  describe :parse_command do
    specify { expect(instance).to respond_to(:parse_command).
      with(1).arguments }
    
    specify "preprocesses the input" do
      instance.should_receive(:preprocess_input).with("lorem ipsum").and_call_original
      instance.parse_command "lorem ipsum"
    end # specify
    
    context "with actions stubbed" do
      before :each do
        actions_source.stub :has_action? do |key|
          [:do, :do_while, :do_not, :doo_wop].include? key
        end # stub
      end # before :each
      
      specify "no matching command" do
        command, arguments = instance.parse_command "Don't stop believing!"
        expect(command).to be nil
      end # specify
      
      specify "matching a simple command" do
        command, arguments = instance.parse_command "Do you hear the people sing?"
        expect(command).to be :do
        expect(arguments).to eq %w(you hear the people sing)
      end # specify
      
      specify "matching a complex command" do
        command, arguments = instance.parse_command "Do while is a useful construct."
        expect(command).to be :do_while
        expect(arguments).to eq %w(is a useful construct)
      end # specify
    end # context
  end # describe
end # describe
