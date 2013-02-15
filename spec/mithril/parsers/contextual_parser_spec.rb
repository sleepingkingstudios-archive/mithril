# spec/mithril/parsers/contextual_parser_spec.rb

require 'mithril/spec_helper'
require 'mithril/parsers/parser_helpers_helper'

require 'mithril/parsers/contextual_parser'

describe Mithril::Parsers::ContextualParser do
  let :actions_source do
    Object.new.tap do |obj| obj.stub :has_action? do false; end; end
  end # let
  
  describe :constructor do
    specify { expect(described_class).to construct.with(1).arguments }
  end # describe
  
  let :instance do described_class.new actions_source; end
  
  it_behaves_like Mithril::Parsers::ParserHelpers
  
  describe :keywords do
    specify { expect(instance).to respond_to(:keywords).with(0).arguments }
    specify { expect(instance.keywords).to be_a Hash }
  end # describe
  
  describe :keywords= do
    specify { expect(instance).to respond_to(:keywords=).with(1).arguments }
    
    specify 'updates the value' do
      instance.keywords = { "foo" => "bar" }
      expect(instance.keywords).to eq({ "foo" => "bar" })
    end # describe
  end # describe
  
  describe :process_arguments do
    specify { expect(instance).to respond_to(:process_arguments).with(1).arguments }
    
    context 'with empty arguments' do
      let :arguments do %w(); end
      
      specify { expect(instance.process_arguments arguments).to eq Hash.new }
    end # context
    
    context 'with no keywords' do
      let :arguments do %w(foo bar baz); end
      
      specify { expect(instance.process_arguments arguments).to eq({ nil => ['foo bar baz'] }) }
    end # context
    
    context 'with keyed text' do
      let :arguments do %w(at foo on bar to baz using wibble with wobble); end
      
      specify "processes the keywords" do
        expect(instance.process_arguments arguments).to eq({
          :combination => %w(wibble wobble),
          :receiver    => %w(baz),
          :target      => %w(foo bar),
        }) # end expect to
      end # specify
    end # context
    
    context 'with mixed text' do
      let :arguments do
        %w(fireball on dragon using phoenix feather using red essence)
      end # let
      
      specify "processes the keywords" do
        expect(instance.process_arguments arguments).to eq({
          nil          => %w(fireball),
          :combination => ["phoenix feather", "red essence"],
          :target      => %w(dragon),
        }) # end expect to
      end # specify
    end # context
    
    context 'with "and" and no keywords' do
      let :arguments do %w(spice and wolf); end
      
      specify { expect(instance.process_arguments arguments).to eq({ nil => %w(spice wolf) }) }
    end # context
    
    context 'with "and" and mixed text' do
      let :arguments do
        %w(ultima weapon to Midgar using black materia and meteor stone)
      end # let
      
      specify "processes the keywords" do
        expect(instance.process_arguments arguments).to eq({
          nil          => ["ultima weapon"],
          :combination => ["black materia", "meteor stone"],
          :receiver    => %w(Midgar),
        }) # end expect to
      end # specify
    end # context
  end # describe
  
  describe :parse_command do
    let :actions_source do
      Object.new.tap do |obj|
        obj.stub :has_action? do |action| [:cast, :grand_summon].include? action; end
      end # tap
    end # let
    
    specify "no matching command" do
      command, arguments = instance.parse_command "attack ogre chieftain"
      expect(command).to be nil
      expect(arguments).to eq({ nil => ["attack ogre chieftain"] })
    end # specify
    
    specify "matching a simple command" do
      text = "cast fireball on dragon using phoenix feather using red essence"
      command, arguments = instance.parse_command text
      expect(command).to be :cast
      expect(arguments).to eq({
        nil          => %w(fireball),
        :combination => ["phoenix feather", "red essence"],
        :target      => %w(dragon),
      }) # end expect to
    end # specify
    
    specify "matching a complex command" do
      text = "grand summon ultima weapon to Midgar using black materia and meteor stone"
      command, arguments = instance.parse_command text
      expect(command).to be :grand_summon
      expect(arguments).to eq({
        nil          => ["ultima weapon"],
        :combination => ["black materia", "meteor stone"],
        :receiver    => %w(Midgar),
      }) # end expect to
    end # specify
  end # describe
end # describe
