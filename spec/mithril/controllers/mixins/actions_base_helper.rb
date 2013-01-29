# spec/mithril/controllers/mixins/actions_base_helper.rb

require 'mithril/controllers/mixins/actions_base'

shared_examples_for Mithril::Controllers::Mixins::ActionsBase do
  let :command do FactoryGirl.generate :action_key; end
  
  specify { expect(instance).not_to respond_to :"action_#{command}" }
  
  describe "self.define_action" do
    specify { expect(described_class).to respond_to(:define_action).
      with(1..2).arguments.and.a_block }
  end # describe
  
  describe "self.actions" do
    specify { expect(described_class).to respond_to(:actions).
      with(0..1).arguments }
    
    specify { expect(described_class.actions).to be_a Hash }
  end # describe
end # shared_examples
