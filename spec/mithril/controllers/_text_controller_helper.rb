# spec/controllers/text_controller_helper.rb

require 'mithril/controllers/abstract_controller_helper'

shared_examples_for "Mithril::Controllers::_TextController" do
  it_behaves_like Mithril::Controllers::AbstractController
  
  let :input do "text input"; end
  
  describe :parser do
    specify { expect(instance.parser).to be_a Mithril::Parsers::SimpleParser }
  end # describe

  describe :parse_command do
    specify { expect(instance.parse_command input).to be_a Array }

    specify "returns nil" do
      command, args = instance.parse_command input
      expect(command).to be nil
    end # specify
  end # describe
  
  describe :command_missing do
    specify "returns the text with a helpful message" do
      output = instance.command_missing input
      expect(output).to match /don't know how/
      expect(output).to match /#{input}/
    end # specify
  end # describe
  
  describe :invoke_command do
    specify "returns the text with a helpful message" do
      output = instance.invoke_command input
      expect(output).to match /don't know how/
      expect(output).to match /#{input}/
    end # specify
  end # describe
  
  context "with actions defined" do
    let :command   do FactoryGirl.generate :action_key; end
    let :arguments do %w(arguments for command); end
    
    before :each do
      described_class.define_action command do |session, args| args.join(' '); end
    end # before each
    
    specify { expect(instance.can_invoke? command.to_s).to be true }
    
    describe :invoke_command do
      let :text do "#{command} #{arguments.join(' ')}"; end
      
      specify "invokes matching action" do
        instance.should_receive(:invoke_action).with(command, arguments).and_call_original
        instance.should_receive(:"action_#{command}").with(request.session, arguments).and_call_original
        instance.invoke_command text
      end # specify
      
      specify { expect(instance.invoke_command text).to eq arguments.join(' ') }
      
      context "with a non-matching command" do
        let :non_matching do FactoryGirl.generate :action_key; end
        
        specify { expect(instance.invoke_command non_matching.to_s).to match /don't know how/i }
      end # context
    end # describe
  end # context
  
  describe "empty actions" do
    def self.input
      chars, words = [*"a".."z", *"0".."9"], [""] * 5
      5.times do |i|
        word = ""
        (6 + rand(10)).times do word << chars[rand(36)]; end
        words[i] = word
      end # times
      words.join " "
    end # helper input
    
    it_behaves_like "Mithril::Controllers::AbstractController#empty_actions", input
  end # describe
end # describe
