# spec/mithril/controllers/mixins/actions_base_spec.rb

require 'mithril/spec_helper'
require 'mithril/controllers/mixins/actions_base_helper'

require 'mithril/controllers/mixins/actions_base'
require 'mithril/controllers/mixins/mixin_with_actions'

describe Mithril::Controllers::Mixins::ActionsBase do
  let :described_class do
    klass = Class.new.extend Mithril::Controllers::Mixins::MixinWithActions
    klass.send :mixin, super()
    klass
  end # let
  let :instance do described_class.new; end
  
  it_behaves_like Mithril::Controllers::Mixins::ActionsBase
end # describe
