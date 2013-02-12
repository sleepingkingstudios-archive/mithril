# spec/mithril/mixin_spec.rb

require 'mithril/spec_helper'
require 'mithril/mixin_helper'

require 'mithril/mixin'

describe Mithril::Mixin do
  let :described_class do Class.new.extend super(); end
  let :instance do described_class.new; end
  
  it_behaves_like Mithril::Mixin
end # describe
