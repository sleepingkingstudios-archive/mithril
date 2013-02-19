# spec/mithril/controllers/abstract_controller_helper.rb

require 'mithril/controllers/mixins/commands_base_helper'

require 'mithril/controllers/abstract_controller'

shared_examples_for Mithril::Controllers::AbstractController do
  it_behaves_like Mithril::Controllers::Mixins::CommandsBase
  
  describe :constructor do
    specify { expect(described_class).to construct.with(1).arguments }
    specify { expect { described_class.new request }.not_to raise_error }
  end # describe
  
  describe :parser do
    specify { expect(instance).to respond_to(:parser).with(0).arguments }
  end # describe
  
  describe :parse_command do
    let :input do Object.new; end
    
    specify { expect(instance).to respond_to(:parse_command).with(1).arguments }
    specify "delegates to the parser" do
      instance.parser.should_receive(:parse_command).with(input)
      instance.parse_command(input)
    end # specify
  end # describe
  
  describe :command_missing do
    let :input do Object.new; end
    
    specify { expect(instance).to respond_to(:command_missing).with(1).arguments }
  end # describe
  
  describe :can_invoke? do
    specify { expect(instance).to respond_to(:can_invoke?).with(1).arguments }
    specify { expect(instance.can_invoke? FactoryGirl.generate(:action_key).to_s).
      to eq false }
  end # describe
  
  describe :invoke_command do
    specify { expect(instance).to respond_to(:invoke_command).with(1).arguments }
  end # describe
  
  context "with actions defined" do
    let :command do FactoryGirl.generate :action_key; end
    
    before :each do described_class.define_action command do |session, args|; end; end
    
    specify { expect(instance.commands).to include command.to_s.gsub('_',' ') }
    
    specify { expect(instance).to have_action command }
    
    describe "inheriting defined actions" do
      let :descendant_class do Class.new described_class; end
      let :instance do descendant_class.new request; end
      
      specify { expect(instance).to have_action command }
    end # describe
  end # context
  
  describe "empty actions" do
    describe :allow_empty_action? do
      specify { expect(instance).to respond_to(:allow_empty_action?).with(0).arguments }
    end # describe
  end # describe
end # shared examples

shared_examples_for "Mithril::Controllers::AbstractController#empty_actions" do |input|
  let :arguments do instance.parse_command(input)[1]; end
  
  before :each do
    if instance.has_action? :""
      instance.stub :_action do |session, arguments| arguments; end
    else
      described_class.send :define_action, :"" do |session, arguments| arguments; end
    end # if-else
  end # before each
  
  context "disallowing empty actions" do
    before :each do instance.stub :allow_empty_action? do false; end; end
    
    specify { expect(instance.allow_empty_action?).to be false }
    
    specify "rejects arbitrary input" do
      expect(instance.can_invoke? input).to be false
    end # describe
  end # context
  
  context "allowing empty actions" do
    before :each do instance.stub :allow_empty_action? do true; end; end
    
    specify { expect(instance.allow_empty_action?).to be true }
    
    specify "accepts arbitrary input" do
      expect(instance.can_invoke? input).to be true
    end # specify
    
    specify "calls invoke action on empty action" do
      instance.should_receive(:invoke_action).with(:"", arguments).and_call_original
      instance.invoke_command input
    end # specify
    
    specify "returns the input" do
      expect(instance.invoke_command input).to eq arguments
    end # specify
  end # context
end # shared examples
