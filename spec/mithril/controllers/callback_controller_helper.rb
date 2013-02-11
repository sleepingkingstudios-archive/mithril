# spec/mithril/controllers/callback_controller_helper.rb

require 'mithril/controllers/abstract_controller_helper'
require 'mithril/controllers/mixins/callback_helpers_helper'
require 'mithril/controllers/mixins/help_actions_helper'

require 'mithril/controllers/callback_controller'

shared_examples_for Mithril::Controllers::CallbackController do
  it_behaves_like Mithril::Controllers::AbstractController
  it_behaves_like Mithril::Controllers::Mixins::CallbackHelpers
  it_behaves_like Mithril::Controllers::Mixins::HelpActions
  
  describe :callbacks do
    specify { expect(instance).to respond_to(:callbacks).with(0).arguments }
    
    specify { expect(instance.callbacks).to be nil }
  end # describe
  
  context 'with callbacks defined in the session' do
    let :action_key do FactoryGirl.generate :action_key; end
    
    before :each do
      klass = Class.new Mithril::Controllers::AbstractController
      klass.send :define_action, action_key do |session, arguments|
        arguments
      end # define action
      
      Mithril::Controllers.const_set :Mock, Module.new
      Mithril::Controllers::Mock.const_set :MockController, klass
    end # before each
    
    after :each do
      Mithril::Controllers::Mock.send :remove_const, :MockController
      Mithril::Controllers.send :remove_const, :Mock
    end # after each
    
    let :command_key do FactoryGirl.generate(:action_key); end
    let :command do command_key.to_s.gsub('_',' '); end
    let :callbacks do
      { command => "Mock::MockController,#{action_key}" }
    end # let
    let :request do
      FactoryGirl.build :request, :session => { :callbacks => callbacks }
    end # let
    let :arguments do %w(with arguments); end
    let :text do "#{command} #{arguments.join(" ")}"; end
    
    specify { expect(instance.callbacks).to eq instance.deserialize_callbacks callbacks }
    
    specify { expect(instance).to have_action command_key }
    specify { expect(instance).to have_command command }
    specify { expect(instance.can_invoke? text).to be true }
    
    specify { expect(instance.invoke_action command_key, arguments).to eq arguments }
    specify { expect(instance.invoke_command text).to eq arguments }
  end # context
end # shared examples
