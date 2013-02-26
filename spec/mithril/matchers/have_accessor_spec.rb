# spec/mithril/matchers/have_accessor_spec.rb

require 'mithril/spec_helper'

describe Mithril::Support::Matchers::HaveAccessor do
  specify { expect(described_class).to construct.with(1).arguments }
  
  let :property do :foo; end
  let :instance do described_class.new property; end
  
  describe :with do
    specify { expect(instance).to respond_to(:with).with(1).arguments }
  end # describe
  
  context 'with a non-compliant object' do
    let :subject do Object.new; end
    
    specify { expect(subject).not_to respond_to(property) }
    
    specify { expect(instance.matches? subject).to be false }
    
    specify { expect(subject).not_to have_accessor property }
    
    specify 'failure message expects actual to have accessor' do
      instance.matches? subject
      expect(instance.failure_message).to match /have accessor #{property}/
    end # specify
    
    context 'with a value' do
      let :value do "foo"; end
      
      specify { expect(instance.with(value).matches? subject).to be false }
      
      specify { expect(instance).not_to have_accessor(property).with(value) }
      
      specify 'failure message expects actual to have accessor with value' do
        instance.with(value).matches? subject
        expect(instance.failure_message).
          to match /have accessor #{property} with value #{value}/
      end # specify
    end # context
  end # context
  
  context 'with a compliant object' do
    let :subject do
      Class.new.tap { |klass| klass.send :attr_reader, property }.new
    end # let
    
    specify { expect(subject).to respond_to(:foo) }
    
    specify { expect(instance.matches? subject).to be true }
    
    specify { expect(subject).to have_accessor property }
    
    specify 'negative failure message expects actual to have accessor' do
      instance.matches? subject
      expect(instance.negative_failure_message).to match /not to have accessor #{property}/
    end # specify
    
    context 'with an incorrect value' do
      let :value do "foo"; end
      
      specify { expect(instance.with(value).matches? subject).to be false }
      
      specify { expect(instance).not_to have_accessor(property).with(value) }
      
      specify 'failure message expects actual to have accessor with value' do
        instance.with(value).matches? subject
        expect(instance.failure_message).
          to match /have accessor #{property} with value #{value}/
      end # specify
    end # context
    
    context 'with a correct value' do
      let :value do "foo"; end
      
      before :each do subject.stub property do value; end; end
      
      specify { expect(instance.with(value).matches? subject).to be true }
      
      specify { expect(subject).to have_accessor(property).with(value) }
      
      specify 'negative failure message expects actual to have accessor with value' do
        instance.with(value).matches? subject
        expect(instance.negative_failure_message).
          to match /not to have accessor #{property} with value #{value}/
      end # specify
    end # context
  end # context
end # describe

