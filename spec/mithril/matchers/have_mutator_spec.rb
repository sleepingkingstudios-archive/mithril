# spec/mithril/matchers/have_mutator_spec.rb

require 'mithril/spec_helper'

describe Mithril::Support::Matchers::HaveMutator do
  specify { expect(described_class).to construct.with(1).arguments }
  
  let :property do :foo; end
  let :instance do described_class.new property; end
  
  describe :with do
    specify { expect(instance).to respond_to(:with).with(1).arguments }
  end # describe
  
  context 'with a non-compliant object' do
    let :subject do Object.new; end
    
    specify { expect(subject).not_to respond_to(:"#{property}=") }
    
    specify { expect(instance.matches? subject).to be false }
    
    specify { expect(subject).not_to have_mutator property }
    
    specify { expect(subject).not_to have_mutator :"#{property}=" }
    
    specify 'failure message expects actual to have mutator' do
      instance.matches? subject
      expect(instance.failure_message).to match /have mutator #{property}/
    end # specify

    context 'with a value' do
      let :value do "foo"; end

      specify { expect(instance.with(value).matches? subject).to be false }

      specify { expect(instance).not_to have_mutator(property).with(value) }
      
      specify { expect(subject).not_to have_mutator(:"#{property}=").with(value) }

      specify 'failure message expects actual to have accessor with value' do
        instance.with(value).matches? subject
        expect(instance.failure_message).
          to match /have mutator #{property} setting value #{value}/
      end # specify
    end # context
  end # context
  
  context 'with a compliant object' do
    let :subject_class do Class.new.tap { |klass| klass.send :attr_writer, property }; end
    let :subject do subject_class.new; end
    
    specify { expect(subject).to respond_to(:"#{property}=") }
    
    specify { expect(instance.matches? subject).to be true }
    
    specify { expect(subject).to have_mutator property }
    
    specify { expect(subject).to have_mutator :"#{property}=" }
    
    specify 'negative failure message expects actual to have mutator' do
      instance.matches? subject
      expect(instance.negative_failure_message).to match /not to have mutator #{property}/
    end # specify

    context 'with an incorrect value' do
      let :value do "foo"; end
      before :each do subject.stub property do nil; end; end

      specify { expect(instance.with(value).matches? subject).to be false }

      specify { expect(instance).not_to have_mutator(property).with(value) }
      
      specify { expect(subject).not_to have_mutator(:"#{property}=").with(value) }

      specify 'failure message expects actual to have mutator with value' do
        instance.with(value).matches? subject
        expect(instance.failure_message).
          to match /have mutator #{property} setting value #{value}/
      end # specify
    end # context

    context 'with a correct value' do
      let :value do "foo"; end
      let :subject_class do super().tap { |klass| klass.send :attr_reader, property }; end

      specify { expect(instance.with(value).matches? subject).to be true }
      
      specify { expect(subject).to have_mutator(property).with(value) }
      
      specify { expect(subject).to have_mutator(:"#{property}=").with(value) }
      
      specify 'negative failure message expects actual to have accessor with value' do
        instance.with(value).matches? subject
        expect(instance.negative_failure_message).
          to match /not to have mutator #{property} setting value #{value}/
      end # specify
    end # context
  end # context
end # describe
