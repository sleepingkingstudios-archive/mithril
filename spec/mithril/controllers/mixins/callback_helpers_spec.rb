# spec/mithril/controllers/mixins/callback_helpers_spec.rb

require 'mithril/spec_helper'
require 'mithril/controllers/mixins/callback_helpers_helper'

require 'mithril/controllers/mixins/callback_helpers'
require 'mithril/controllers/mixins/mixin_with_actions'

describe Mithril::Controllers::Mixins::CallbackHelpers do
  let :described_class do
    klass = Class.new
    klass.send :extend, Mithril::Controllers::Mixins::MixinWithActions
    klass.send :mixin,  super()
    klass
  end # described_class
  let :instance do described_class.new; end
  
  it_behaves_like Mithril::Controllers::Mixins::CallbackHelpers
end # describe
