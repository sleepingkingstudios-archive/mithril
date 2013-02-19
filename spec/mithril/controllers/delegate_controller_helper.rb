# spec/mithril/controllers/delegate_controller_helper.rb

require 'mithril/controllers/abstract_controller_helper'

require 'mithril/controllers/delegate_controller'

shared_examples_for Mithril::Controllers::DelegateController do
  it_behaves_like Mithril::Controllers::AbstractController
  
  describe :delegate_to do
    specify { expect(instance).to respond_to(:delegate_to).with(0..9001).arguments }
    
    context 'with delegates' do
      let :delegates do [].tap do |ary|
        5.times do ary << Object.new.tap do |obj| obj.stub :delegated_to; end; end
      end; end # let
      
      specify 'calls :delegated_to hook on delegates' do
        delegates.each do |delegate|
          delegate.should_receive(:delegated_to).with(instance)
         end # each
         
         instance.delegate_to *delegates
      end # specify
    end # context
  end # describe
end # shared_examples_for
