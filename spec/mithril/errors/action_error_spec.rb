# spec/mithril/errors/action_error_spec.rb

require 'mithril/spec_helper'

require 'mithril/controllers/abstract_controller'
require 'mithril/errors/action_error'

describe Mithril::Errors::ActionError do
  specify { expect(described_class).to be < StandardError }
  
  describe "constructor" do
    specify { expect(described_class).to construct.with(5).arguments }
  end # describe
  
  let :message do "don't panic"; end
  let :controller do Mithril::Controllers::AbstractController; end
  let :action do FactoryGirl.generate :action_key; end
  let :session do { :foo => :bar }; end
  let :arguments do %w(some arguments); end
  let :instance do
    described_class.new message, controller, action, session, arguments
  end # let
  
  describe :message do
    specify { expect(instance).to respond_to(:message).with(0).arguments }
    specify { expect(instance.message).to be message }
  end # describe
  
  describe :controller do
    specify { expect(instance).to respond_to(:controller).with(0).arguments }
    specify { expect(instance.controller).to be controller }
  end # describe
  
  describe :action do
    specify { expect(instance).to respond_to(:action).with(0).arguments }
    specify { expect(instance.action).to be action }
  end # describe
  
  describe :session do
    specify { expect(instance).to respond_to(:session).with(0).arguments }
    specify { expect(instance.session).to be session }
  end # describe
  
  describe :arguments do
    specify { expect(instance).to respond_to(:arguments).with(0).arguments }
    specify { expect(instance.arguments).to be arguments }
  end # describe
end # describe
