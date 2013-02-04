# spec/mithril/controllers/mixins/help_actions_spec.rb

require 'mithril/spec_helper'
require 'mithril/controllers/mixins/help_actions_helper'

require 'mithril/controllers/mixins/help_actions'
require 'mithril/controllers/mixins/mixin_with_actions'

describe Mithril::Controllers::Mixins::HelpActions do
  let :described_class do
    klass = Class.new
    klass.send :extend, Mithril::Controllers::Mixins::MixinWithActions
    klass.send :mixin, super();
    klass
  end # let
  let :instance do described_class.new; end
  
  it_behaves_like Mithril::Controllers::Mixins::HelpActions
end # describe
