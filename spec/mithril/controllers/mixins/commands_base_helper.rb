# spec/mithril/controllers/mixins/commands_base_helper.rb

require 'mithril/controllers/mixins/actions_base_helper'

require 'mithril/controllers/mixins/commands_base'

shared_examples_for Mithril::Controllers::Mixins::CommandsBase do
  it_behaves_like Mithril::Controllers::Mixins::ActionsBase
  
  describe :commands do
    specify { expect(instance).to respond_to(:commands).with(0).arguments }
    specify { expect(instance.commands).to be_a Array }
  end # describe
  
  describe :has_command? do
    specify { expect(instance).to respond_to(:has_command?).with(1).arguments }
    specify { expect(instance).not_to have_command FactoryGirl.generate :action_key }
  end # describe
end # shared examples
