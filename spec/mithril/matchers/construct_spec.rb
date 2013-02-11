# spec/matchers/construct_spec.rb

require 'mithril/spec_helper'

describe "construct matcher" do
  let :class_with_no_arguments do Class.new; end
  let :class_with_arguments do
    Class.new do def initialize(a, b, c = nil); end; end
  end # let
  let :not_a_class do Object.new; end
  
  specify { expect(class_with_no_arguments).to construct }
  specify { expect(class_with_arguments).to construct }
  specify { expect(not_a_class).not_to construct }
  
  describe "with a fixed number of arguments" do
    specify { expect(class_with_no_arguments).to construct.
      with(0).arguments }
    specify { expect(class_with_no_arguments).not_to construct.
      with(1).arguments }
    
    specify { expect(class_with_arguments).not_to construct.
      with(1).arguments }
    specify { expect(class_with_arguments).to construct.
      with(2).arguments }
    specify { expect(class_with_arguments).to construct.
      with(3).arguments }
    specify { expect(class_with_arguments).not_to construct.
      with(4).arguments }
  end # describe
  
  describe "with a range of arguments" do
    specify { expect(class_with_no_arguments).to construct.
      with(0..0).arguments }
    specify { expect(class_with_no_arguments).not_to construct.
      with(0..1).arguments }
    specify { expect(class_with_no_arguments).not_to construct.
      with(1..2).arguments }
    
    specify { expect(class_with_arguments).not_to construct.
      with(1..4).arguments }
    specify { expect(class_with_arguments).not_to construct.
      with(1..3).arguments }
    specify { expect(class_with_arguments).not_to construct.
      with(2..4).arguments }
    specify { expect(class_with_arguments).to construct.
      with(2..3).arguments }
  end # describe
end # describe
