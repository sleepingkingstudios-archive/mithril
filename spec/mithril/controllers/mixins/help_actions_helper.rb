# spec/mithril/controllers/mixins/help_actions_helper.rb

require 'mithril/controllers/mixins/actions_base_helper'

require 'mithril/controllers/mixins/help_actions'

shared_examples_for Mithril::Controllers::Mixins::HelpActions do
  it_behaves_like Mithril::Controllers::Mixins::ActionsBase
  
  describe :help_message do
    specify { expect(instance).to respond_to(:help_message).with(0).arguments }
    specify { expect(instance.help_message).to be_a String }
  end # describe
  
  describe "help action" do
    specify { expect(instance).to have_action :help }
    
    context "with a help string defined" do
      let :arguments do %w(); end
      
      before :each do
        instance.stub :help_message do
          "You put your left foot in, you take your left foot out."
        end # stub
      end # before each
      
      specify { expect(instance.invoke_action :help, arguments).
        to match /put your left foot in/i }
      
      specify { expect(instance.invoke_action :help, arguments).
        to match /following commands are available/i }
    end # context
    
    describe "with no arguments" do
      let :arguments do %w(); end
      
      specify { expect(instance.invoke_action :help, arguments).
        to match /following commands are available/i }
      specify { expect(instance.invoke_action :help, arguments).
        to match /help/i }
    end # context
    
    describe "with help" do
      let :arguments do %w(help); end
      
      specify { expect(instance.invoke_action :help, arguments).
        to match /the help command/i }
    end # describe
  end # describe
  
  context "with additional actions defined" do
    let :action_keys do
      [].tap do |ary|
        1.times do ary << FactoryGirl.generate(:action_key); end
      end # tap
    end # let
    
    before :each do
      action_keys.each do |key|
        described_class.send :define_action, key do |session, arguments|; end
      end # each
    end # before each
    
    describe "help action" do
      specify "lists available commands" do
        (action_keys << :help).each do |key|
          command = key.to_s.gsub('_',' ')
          expect(instance.invoke_action :help, %w()).to match /#{command}/
        end # each
      end # specify
      
      specify "invokes the command with help" do
        session = instance.request ? (instance.request.session || {}) : {}
        action_keys.each do |key|
          command = key.to_s.gsub('_',' ')
          instance.should_receive(:"action_#{key}").with(session, %w(help))
          instance.invoke_action :help, command.split(' ')
        end # each
      end # specify
    end # describe
  end # context
  
  context "with additional commands defined" do
    let :commands do
      [].tap do |ary|
        1.times do ary << FactoryGirl.generate(:action_key).to_s.gsub('_', ' '); end
      end # tap
    end # let
    
    before :each do
      instance.stub :commands do commands; end
      instance.stub :has_command? do |command| commands.include? command; end
    end # before each
    
    describe "help action" do
      specify "lists available commands" do
        (commands << "help").each do |command|
          expect(instance.invoke_action :help, %w()).to match /#{command}/
        end # each
      end # specify
      
      specify "invokes the command with help" do
        session = instance.request ? (instance.request.session || {}) : {}
        commands.each do |command|
          instance.should_receive(:invoke_command).with("#{command} help")
          instance.invoke_action :help, [command]
        end # each
      end # specify
    end # describe
  end # context
end # shared examples
