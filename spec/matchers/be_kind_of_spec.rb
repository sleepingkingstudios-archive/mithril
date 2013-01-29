# spec/matchers/be_kind_of_spec.rb

require 'spec_helper'

describe RSpec::Matchers::BuiltIn::BeAKindOf do
  let :custom_module do Module.new; end
  let :custom_class do Class.new.tap { |c| c.send :include, custom_module }; end
  let :custom_subclass do Class.new custom_class; end
  
  let :string do "string"; end
  let :module_instance do Object.new.extend custom_module; end
  let :class_instance do custom_class.new; end
  let :subclass_instance do custom_subclass.new; end
  
  describe "with type" do
    specify { expect(nil).to be_a NilClass }
    specify { expect(nil).not_to be_a String }
    
    specify { expect(string).to be_a String }
    specify { expect(string).not_to be_a custom_class }
    
    specify { expect(module_instance).to be_a custom_module }
    specify { expect(module_instance).not_to be_a custom_class }
    
    specify { expect(class_instance).to be_a custom_module }
    specify { expect(class_instance).to be_a custom_class }
    specify { expect(class_instance).not_to be_a String }
    
    specify { expect(subclass_instance).to be_a custom_module }
    specify { expect(subclass_instance).to be_a custom_class }
    specify { expect(subclass_instance).to be_a custom_subclass }
    specify { expect(subclass_instance).not_to be_a String }
  end # describe
  
  describe "with nil" do
    specify { expect(nil).to be_a nil }
    specify { expect(string).not_to be_a nil }
  end # describe
  
  describe "with array of types" do
    specify { expect(nil).to be_a [String, nil] }
    specify { expect(nil).not_to be_a [custom_class, String] }
    
    specify { expect(string).to be_a [custom_module, String, nil] }
    specify { expect(string).not_to be_a [custom_subclass, nil] }
    
    specify { expect(subclass_instance).to be_a [custom_class, String] }
    specify { expect(subclass_instance).not_to be_a [nil, String] }
  end # describe
end # describe
