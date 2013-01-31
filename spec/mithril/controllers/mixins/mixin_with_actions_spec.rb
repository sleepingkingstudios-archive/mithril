# spec/mithril/controllers/mixins/action_mixin_spec.rb

require 'spec_helper'
require 'mithril/mixin_helper'

require 'mithril/controllers/mixins/mixin_with_actions'

describe Mithril::Controllers::Mixins::MixinWithActions do
  let :described_class do
    klass = Class.new.extend super()
    klass.instance_eval do def actions; @actions; end; end
    klass.send :mixin, ancestor_module
    klass
  end # let
  let :instance do described_class.new; end
  
  it_behaves_like Mithril::Mixin
  
  let :ancestor_actions do
    hsh = {}
    5.times do hsh[FactoryGirl.generate(:action_key)] = true; end
    hsh
  end # let
  let :ancestor_module do
    mod = Module.new
    mod.send :extend, Mithril::Controllers::Mixins::MixinWithActions
    mod.instance_eval do def actions; @actions; end; end
    mod.instance_variable_set :@actions, ancestor_actions
    mod
  end # let
  
  context "with a direct mixin" do
    before :each do
      described_class.send :mixin, ancestor_module
      described_class.instance_eval do def actions; @actions; end; end
    end # before each
    
    specify "actions are inherited" do
      ancestor_actions.each_key do |action|
        expect(described_class.actions).to have_key action
      end # each
    end # specify
  end # context
end # describe
