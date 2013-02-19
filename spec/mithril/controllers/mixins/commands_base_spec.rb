# spec/mithril/controllers/mixins/commands_base_spec.rb

require 'mithril/spec_helper'
require 'mithril/controllers/mixins/commands_base_helper'

require 'mithril/controllers/mixins/commands_base'

describe Mithril::Controllers::Mixins::CommandsBase do
  let :described_class do
    klass = Class.new.extend Mithril::Controllers::Mixins::MixinWithActions
    klass.send :mixin, super()
    klass
  end # let
  let :instance do described_class.new; end
  
  it_behaves_like Mithril::Controllers::Mixins::CommandsBase
end # describe
