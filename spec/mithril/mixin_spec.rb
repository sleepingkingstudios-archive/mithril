# spec/mithril/mixin_spec.rb

require 'spec_helper'
require 'mithril/mixin_helper'

require 'mithril/mixin'

describe Mithril::Mixin do
  let :described_class do
    klass = Class.new.extend super()
    klass.send :mixin, ancestor_module
    klass
  end # let
  let :instance do described_class.new; end
  
  it_behaves_like Mithril::Mixin
end # describe
