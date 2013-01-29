# spec/matchers/respond_to_spec.rb

require 'spec_helper'

describe RSpec::Matchers::BuiltIn::RespondTo do
  let :described_class do
    Class.new do
      def method_with_no_arguments; end
      
      def method_with_required_arguments(a, b, c); end
      
      def method_with_optional_arguments(a, b, c = nil, d = nil); end
      
      def method_with_variadic_arguments(a, b, c, *rest); end
      
      def method_with_mixed_arguments(a, b, c = nil, d = nil, *rest); end
      
      def method_with_yield; yield; end
      
      def method_with_block_argument(&block); end
      
      def method_with_block_and_mixed_arguments(a, b = nil, *rest, &block); end
    end # class
  end # let
  let :instance do described_class.new; end
  
  describe :respond_to do
    specify { expect(instance).to respond_to :method_with_no_arguments }
    specify { expect(instance).to respond_to :method_with_required_arguments }
    specify { expect(instance).to respond_to :method_with_optional_arguments }
    specify { expect(instance).to respond_to :method_with_variadic_arguments }
    specify { expect(instance).to respond_to :method_with_yield }
    specify { expect(instance).to respond_to :method_with_mixed_arguments }
    specify { expect(instance).to respond_to :method_with_block_argument }
    
    specify { expect(instance).not_to respond_to :not_a_method }
    
    describe "with a fixed number of arguments" do
      specify { expect(instance).to respond_to(:method_with_no_arguments).
        with(0).arguments }
      specify { expect(instance).not_to respond_to(:method_with_no_arguments).
        with(1).arguments }
      
      specify { expect(instance).not_to respond_to(:method_with_required_arguments).
        with(2).arguments }
      specify { expect(instance).to respond_to(:method_with_required_arguments).
        with(3).arguments }
      specify { expect(instance).not_to respond_to(:method_with_required_arguments).
        with(4).arguments }
      
      specify { expect(instance).not_to respond_to(:method_with_optional_arguments).
        with(1).arguments }
      specify { expect(instance).to respond_to(:method_with_optional_arguments).
        with(2).arguments }
      specify { expect(instance).to respond_to(:method_with_optional_arguments).
        with(3).arguments }
      specify { expect(instance).to respond_to(:method_with_optional_arguments).
        with(4).arguments }
      specify { expect(instance).not_to respond_to(:method_with_optional_arguments).
        with(5).arguments }
        
      specify { expect(instance).not_to respond_to(:method_with_variadic_arguments).
        with(2).arguments }
      specify { expect(instance).to respond_to(:method_with_variadic_arguments).
        with(3).arguments }
      specify { expect(instance).to respond_to(:method_with_variadic_arguments).
        with(4).arguments }
      specify { expect(instance).to respond_to(:method_with_variadic_arguments).
        with(9001).arguments } # IT'S OVER NINE THOUSAND!
      
      specify { expect(instance).not_to respond_to(:method_with_mixed_arguments).
        with(1).arguments }
      specify { expect(instance).to respond_to(:method_with_mixed_arguments).
        with(2).arguments }
      specify { expect(instance).to respond_to(:method_with_mixed_arguments).
        with(3).arguments }
      specify { expect(instance).to respond_to(:method_with_mixed_arguments).
        with(4).arguments }
      specify { expect(instance).to respond_to(:method_with_mixed_arguments).
        with(5).arguments }
      specify { expect(instance).to respond_to(:method_with_mixed_arguments).
        with(9001).arguments } # WHAT?! NINE THOUSAND!
    end # describe
    
    describe "with a range of arguments" do
      specify { expect(instance).to respond_to(:method_with_no_arguments).
        with(0..0).arguments }
      specify { expect(instance).not_to respond_to(:method_with_no_arguments).
        with(0..1).arguments }
      
      specify { expect(instance).not_to respond_to(:method_with_required_arguments).
        with(0..3).arguments }
      specify { expect(instance).not_to respond_to(:method_with_required_arguments).
        with(2..3).arguments }
      specify { expect(instance).not_to respond_to(:method_with_required_arguments).
        with(3..4).arguments }
      specify { expect(instance).to respond_to(:method_with_required_arguments).
        with(3..3).arguments }
      
      specify { expect(instance).not_to respond_to(:method_with_optional_arguments).
        with(0..4).arguments }
      specify { expect(instance).not_to respond_to(:method_with_optional_arguments).
        with(2..5).arguments }
      specify { expect(instance).to respond_to(:method_with_optional_arguments).
        with(2..2).arguments }
      specify { expect(instance).to respond_to(:method_with_optional_arguments).
        with(2..3).arguments }
      specify { expect(instance).to respond_to(:method_with_optional_arguments).
        with(2..4).arguments }
      specify { expect(instance).to respond_to(:method_with_optional_arguments).
        with(3..4).arguments }
      specify { expect(instance).to respond_to(:method_with_optional_arguments).
        with(4..4).arguments }
        
      specify { expect(instance).not_to respond_to(:method_with_variadic_arguments).
        with(0..4).arguments }
      specify { expect(instance).not_to respond_to(:method_with_variadic_arguments).
        with(2..4).arguments }
      specify { expect(instance).to respond_to(:method_with_variadic_arguments).
        with(3..4).arguments }
      specify { expect(instance).to respond_to(:method_with_variadic_arguments).
        with(5..9).arguments }
      specify { expect(instance).to respond_to(:method_with_variadic_arguments).
        with(3..9001).arguments } # VEGETA, WHAT DOES...NEVER MIND, JOKE'S OVER
      
      specify { expect(instance).not_to respond_to(:method_with_mixed_arguments).
        with(0..5).arguments }
      specify { expect(instance).not_to respond_to(:method_with_mixed_arguments).
        with(1..5).arguments }
      specify { expect(instance).to respond_to(:method_with_mixed_arguments).
        with(2..5).arguments }
      specify { expect(instance).to respond_to(:method_with_mixed_arguments).
        with(3..5).arguments }
      specify { expect(instance).to respond_to(:method_with_mixed_arguments).
        with(4..5).arguments }
      specify { expect(instance).to respond_to(:method_with_mixed_arguments).
        with(5..5).arguments }
      specify { expect(instance).to respond_to(:method_with_mixed_arguments).
        with(2..9001).arguments } # THERE'S NO WAY THAT CAN BE RIGHT. CAN IT?!?
    end # describe
    
    describe "with a block" do
      specify { expect(instance).not_to respond_to(:method_with_no_arguments).
        with.a_block }
      
      specify { expect(instance).not_to respond_to(:method_with_yield).
        with.a_block }
      
      specify { expect(instance).to respond_to(:method_with_block_argument).
        with.a_block }
      specify { expect(instance).to respond_to(:method_with_block_argument).
        with(0).arguments.and.a_block }
      
      specify { expect(instance).to respond_to(:method_with_block_and_mixed_arguments).
        with.a_block }
      specify { expect(instance).to respond_to(:method_with_block_and_mixed_arguments).
        with(2..9001).arguments.and.a_block } # FINE, FINE. KILLJOYS.
    end # describe
  end # describe
end # describe
