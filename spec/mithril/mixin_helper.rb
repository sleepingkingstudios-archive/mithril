# spec/mithril/mixin_helper.rb

require 'mithril/mixin'

shared_examples_for Mithril::Mixin do
  let :ancestor_instance_method do FactoryGirl.generate(:action_key); end
  let :ancestor_class_method do FactoryGirl.generate(:action_key); end
  let :ancestor_module do
    mod = Module.new
    mod.send :extend, Mithril::Mixin
    mod.send :define_method, ancestor_instance_method do; end
    mod.const_set :ClassMethods, Module.new
    mod::ClassMethods.send :define_method, ancestor_class_method do; end
    mod
  end # let
  
  let :parent_instance_method do FactoryGirl.generate(:action_key); end
  let :parent_class_method do FactoryGirl.generate(:action_key); end
  let :parent_module do
    mod = Module.new
    mod.send :extend, Mithril::Mixin
    mod.send :mixin, ancestor_module
    mod.send :define_method, parent_instance_method do; end
    mod.const_set :ClassMethods, Module.new
    mod::ClassMethods.send :define_method, parent_class_method do; end
    mod
  end # let
  
  context "with a direct mixin" do
    before :each do described_class.send :mixin, ancestor_module; end
    
    describe "instance methods are mixed in" do
      specify { expect(instance).to respond_to ancestor_instance_method }
    end # describe
    
    describe "class method are mixed in" do
      specify { expect(described_class).to respond_to ancestor_class_method }
    end # describe
  end # context
  
  context "with a cascading mixin" do
    before :each do described_class.send :mixin, parent_module; end
    
    describe "instance methods are mixed in" do
      specify { expect(instance).to respond_to ancestor_instance_method }
      specify { expect(instance).to respond_to parent_instance_method }
    end # describe
    
    describe "class method are mixed in" do
      specify { expect(described_class).to respond_to ancestor_class_method }
      specify { expect(described_class).to respond_to parent_class_method }
    end # describe
  end # context
end # shared examples