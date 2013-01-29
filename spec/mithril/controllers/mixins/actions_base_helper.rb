# spec/mithril/controllers/mixins/actions_base_helper.rb

require 'mithril/controllers/mixins/actions_base'
require 'mithril/request'

shared_examples_for Mithril::Controllers::Mixins::ActionsBase do
  let :command do FactoryGirl.generate :action_key; end
  
  specify { expect(instance).not_to respond_to :"action_#{command}" }
  
  describe "self.define_action" do
    specify { expect(described_class).to respond_to(:define_action).
      with(1..2).arguments.and.a_block }
  end # describe
  
  describe "self.actions" do
    specify { expect(described_class).to respond_to(:actions).with(0..1).arguments }
    
    specify { expect(described_class.actions).to be_a Hash }
  end # describe
  
  describe :request do
    specify { expect(instance).to respond_to(:request).with(0).arguments }
    specify { expect(instance.request).to be_a [Mithril::Request, nil] }
  end # describe
  
  describe :actions do
    specify { expect(instance).to respond_to(:actions).with(0..1).arguments }
    specify { expect(instance.actions).to be_a Hash }
  end # describe
  
  describe :has_action? do
    let :command do FactoryGirl.generate :action_key; end
    
    specify { expect(instance).to respond_to(:has_action?).with(1..2).arguments }
    specify { expect(instance.has_action? command).to be false }
    specify { expect(instance.has_action? command, true).to be false }
  end # describe
  
  describe :invoke_action do
    specify { expect(instance).to respond_to(:invoke_action).with(2..3).arguments }
  end # describe
  
  context "with an action defined" do
    let :command do FactoryGirl.generate :action_key; end
    
    before :each do
      described_class.define_action command do |session, arguments| arguments.join(" "); end
    end # before each
    
    specify { expect(described_class.actions).to have_key command }
    specify { expect(described_class.actions true).to have_key command }
    
    specify { expect(instance.actions).to have_key command }
    specify { expect(instance.actions true).to have_key command }
    
    specify { expect(instance).to have_action command }
    specify { expect(instance).to have_action command, true }
    
    describe :invoke_action do
      let :request do defined?(super) ? super() : FactoryGirl.build(:request); end
      let :arguments do %w(some args); end
      let :output do arguments.join(" "); end
      
      before :each do instance.stub :request do request; end; end
      
      specify "calls the defined method" do
        instance.should_receive(:"action_#{command}").with(request.session, arguments)
        instance.invoke_action command, arguments
      end # specify
      
      specify "calls the defined method as private" do
        instance.should_receive(:"action_#{command}").with(request.session, arguments)
        instance.invoke_action command, arguments, true
      end # specify
      
      specify { instance.invoke_action(command, arguments).should eq output }
      specify { instance.invoke_action(command, arguments, true).should eq output }
    end # describe
  end # context
  
  describe "with a private action defined" do
    let :command do FactoryGirl.generate :action_key; end
    
    before :each do
      described_class.define_action command, :private => true do |session, arguments|
        arguments.join(" ")
      end # define action
    end # before each
    
    specify { expect(described_class.actions).not_to have_key command }
    specify { expect(described_class.actions true).to have_key command }
    
    specify { expect(instance.actions).not_to have_key command }
    specify { expect(instance.actions true).to have_key command }
    
    specify { expect(instance).not_to have_action command }
    specify { expect(instance).to have_action command, true }
    
    describe :invoke_action do
      let :request do defined?(super) ? super() : FactoryGirl.build(:request); end
      let :arguments do %w(some args); end
      let :output do arguments.join(" "); end
      
      before :each do instance.stub :request do request; end; end
      
      specify "calls the defined method" do
        instance.should_not_receive(:"action_#{command}")
        instance.invoke_action command, arguments
      end # specify
      
      specify "calls the defined method as private" do
        instance.should_receive(:"action_#{command}").with(request.session, arguments)
        instance.invoke_action command, arguments, true
      end # specify
      
      specify { instance.invoke_action(command, arguments).should be nil }
      specify { instance.invoke_action(command, arguments, true).should eq output }
    end # describe
  end # describe
end # shared_examples
