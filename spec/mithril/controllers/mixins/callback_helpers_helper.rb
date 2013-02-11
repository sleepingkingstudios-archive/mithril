# spec/mithril/controllers/mixins/callback_helpers_helper.rb

require 'mithril/controllers/mixins/callback_helpers'

shared_examples_for Mithril::Controllers::Mixins::CallbackHelpers do
  describe :controller? do
    specify { expect(instance).to respond_to(:controller?).with(1).arguments }
    
    specify { expect(instance.controller? nil).to be false }
    specify { expect(instance.controller? Object.new).to be false }
    
    context 'with a controller' do
      let :controller do Mithril::Controllers::AbstractController; end
      
      specify { expect(instance.controller? controller).to be true }
    end # context
    
    context 'with a subclass of controller' do
      let :controller do Class.new Mithril::Controllers::AbstractController; end
      
      specify { expect(instance.controller? controller).to be true }
    end # context
  end # describe controller?
  
  describe :namespaces do
    specify { expect(instance).to respond_to(:namespaces).with(0).arguments }
    specify { expect(instance.namespaces).to be_a Array }
    specify { expect(instance.namespaces).to include "Mithril::Controllers" }
    
    describe "appending namespaces" do
      let :namespace do "SpaceParanoids::Controllers"; end
      
      specify "appended namespaces are persisted" do
        instance.namespaces << namespace
        expect(instance.namespaces).to include namespace
      end # specify
    end # describe
  end # describe
  
  describe :resolve_controller do
    specify { expect(instance).to respond_to(:resolve_controller).with(1).arguments }
    
    specify { expect(instance.resolve_controller nil).to be nil }
    specify { expect(instance.resolve_controller "").to be nil }
    
    context 'with an invalid path' do
      let :path do "NotAController"; end
      
      specify { expect(instance.resolve_controller path).to be nil }
    end # context
    
    context 'with a valid controller' do
      let :path do "AbstractController"; end
      
      specify { expect(instance.resolve_controller path).
        to be Mithril::Controllers::AbstractController }
    end # context
    
    context 'with a valid controller in a submodule' do
      before :each do
        Mithril::Controllers.const_set :Mock, Module.new
        Mithril::Controllers::Mock.const_set :MockController,
          Class.new(Mithril::Controllers::AbstractController)
      end # before each
      
      after :each do
        Mithril::Controllers::Mock.send :remove_const, :MockController
        Mithril::Controllers.send :remove_const, :Mock
      end # after each
      
      let :path do "Mock::MockController"; end
      
      specify { expect(instance.resolve_controller path).
        to be Mithril::Controllers::Mock::MockController }
    end # context
    
    context 'with a valid controller in another namespace' do
      before :each do
        Kernel.const_set :SpaceParanoids, Module.new
        SpaceParanoids.const_set :Controllers, Module.new
        SpaceParanoids::Controllers.const_set :MockController,
          Class.new(Mithril::Controllers::AbstractController)
      end # before each
      
      after :each do
        SpaceParanoids::Controllers.send :remove_const, :MockController
        SpaceParanoids.send :remove_const, :Controllers
        Kernel.send :remove_const, :SpaceParanoids
      end # after each
      
      let :namespace do "SpaceParanoids::Controllers"; end
      let :path do "MockController"; end
      
      specify "returns the controller" do
        instance.namespaces << namespace
        expect(instance.resolve_controller path).
          to be SpaceParanoids::Controllers::MockController
      end # specify
    end # context
  end # describe
  
  describe :get_callbacks do
    let :callback_key do :callbacks; end
    let :session do Hash.new; end
    
    before :each do instance.stub :callback_key do callback_key; end; end
    
    specify { expect(instance).to respond_to(:get_callbacks).with(1).arguments }
    
    specify { expect(instance.get_callbacks session).to be nil }
    
    context 'with callback data defined' do
      let :callback_data do "callback data"; end
      let :session do { callback_key => callback_data }; end
      
      specify { expect(instance.get_callbacks session).to be callback_data }
    end # context
  end # describe
  
  describe :set_callbacks do
    let :callback_key do :callbacks; end
    let :callback_data do "callback data"; end
    let :session do Hash.new; end
    
    before :each do instance.stub :callback_key do callback_key; end; end
    
    specify { expect(instance).to respond_to(:set_callbacks).with(2).arguments }
    
    specify "updates the session" do
      instance.set_callbacks session, callback_data
      expect(session[callback_key]).to be callback_data
    end # specify
  end # describe
  
  describe :clear_callbacks do
    let :callback_key do :callbacks; end
    let :callback_data do "callback data"; end
    let :session do { callback_key => callback_data, :other_key => "other data" }; end
    
    before :each do instance.stub :callback_key do callback_key; end; end
    
    specify { expect(instance).to respond_to(:clear_callbacks).with(1).arguments }
    
    specify "removes the callback data" do
      instance.clear_callbacks session
      expect(session[callback_key]).to be nil
    end # specify
    
    specify "does not remove other data" do
      instance.clear_callbacks session
      expect(session[:other_key]).to eq "other data"
    end # specify
  end # describe
  
  describe :has_callbacks? do
    let :callback_key do :callbacks; end
    let :callback_data do "callback data"; end
    let :session do Hash.new; end
    
    before :each do instance.stub :callback_key do callback_key; end; end
    
    specify { expect(instance).to respond_to(:has_callbacks?).with(1).arguments }
    
    specify { expect(instance.has_callbacks? session).to be false }
    
    context 'with callback data defined' do
      let :session do { callback_key => callback_data, :other_key => "other data" }; end
      
      specify { expect(instance.has_callbacks? session).to be true }
    end # context
  end # describe
  
  describe :serialize_callbacks do
    let :callback_command    do "command"; end
    let :callback_action     do FactoryGirl.generate :action_key; end
    let :callback_controller do Mithril::Controllers::AbstractController; end
    
    let :callbacks do { callback_command =>
      { :controller => callback_controller, :action => callback_action }
    } end # let
    
    specify { expect(instance).to respond_to(:serialize_callbacks).with(1).arguments }
    
    context 'with an empty callbacks hash' do
      let :callbacks do {}; end
      
      specify { expect { instance.serialize_callbacks(callbacks) }.
        to raise_error Mithril::Errors::CallbackError,
        /empty callbacks hash/ }
    end # context
    
    context 'with a nil controller' do
      let :callbacks do { callback_command => { :action => callback_action } }; end
      
      specify { expect { instance.serialize_callbacks callbacks }.
        to raise_error Mithril::Errors::CallbackError,
        /malformed callbacks hash/ }
      
      specify "raises error with message" do
        begin
          instance.serialize_callbacks callbacks
        rescue Mithril::Errors::CallbackError => exception
          expect(exception.errors[callback_command]).
            to include_matching(/expected controller not to be nil/i)
        end # begin-rescue
      end # specify
    end # context
    
    context 'with an invalid controller' do
      before :each do
        Mithril::Controllers.const_set :NotAController, Class.new
      end # before each
      
      after :each do
        Mithril::Controllers.send :remove_const, :NotAController
      end # before each
      
      let :callbacks do { callback_command => 
        { :controller => Mithril::Controllers::NotAController, :action => callback_action }
      }; end
      
      specify { expect { instance.serialize_callbacks callbacks }.
        to raise_error Mithril::Errors::CallbackError,
        /malformed callbacks hash/ }
      
      specify "raises error with message" do
        begin
          instance.serialize_callbacks callbacks
        rescue Mithril::Errors::CallbackError => exception
          expect(exception.errors[callback_command]).
            to include_matching(/expected controller to extend AbstractController/i)
        end # begin-rescue
      end # specify
    end # context
    
    context 'with a nil action' do
      let :callbacks do { callback_command => { :controller => callback_controller }}; end
      
      specify { expect { instance.serialize_callbacks callbacks }.
        to raise_error Mithril::Errors::CallbackError,
        /malformed callbacks hash/ }
      
      specify "raises error with message" do
        begin
          instance.serialize_callbacks callbacks
        rescue Mithril::Errors::CallbackError => exception
          expect(exception.errors[callback_command]).
            to include_matching(/expected action not to be nil/i)
        end # begin-rescue
      end # specify
    end # context
    
    context 'with valid controllers and actions' do
      let :callback_actions do
        [].tap do |ary| 3.times do ary << FactoryGirl.generate(:action_key); end; end
      end # let
      
      let :callbacks do
        {}.tap do |hsh|
          callback_actions.each do |action|
            hsh[action.to_s.gsub(/action/, 'command')] =
              { :controller => callback_controller, :action => action }
          end # each
        end # tap
      end # let
      
      specify { expect { instance.serialize_callbacks callbacks }.not_to raise_error }
      
      specify 'formats the callbacks for serialization' do
        hsh = instance.serialize_callbacks callbacks
        
        expect(hsh.keys.sort).to eq callback_actions.map { |action|
          action.to_s.gsub(/action/, 'command')
        }.sort
        
        controller = callback_controller.to_s.split("::").last
        callback_actions.each do |action|
          command = action.to_s.gsub(/action/, 'command')
          expect(hsh[command]).to eq "#{controller},#{action}"
        end # each
      end # specify
    end # context
  end # describe
  
  describe :deserialize_callbacks do
    let :callback_command    do "command"; end
    let :callback_action     do FactoryGirl.generate :action_key; end
    let :callback_controller do Mithril::Controllers::AbstractController; end
    
    let :callbacks do
      { callback_command => "#{callback_controller.to_s.split("::").last},#{callback_action}" }
    end # let
    
    specify { expect(instance).to respond_to(:deserialize_callbacks).with(1).arguments }
    
    context 'with an empty callbacks hash' do
      let :callbacks do {}; end
      
      specify { expect { instance.deserialize_callbacks(callbacks) }.
        to raise_error Mithril::Errors::CallbackError,
        /empty callbacks hash/ }
    end # context
    
    context 'with a nil callback' do
      let :callbacks do { nil => "" }; end
      
      specify { expect { instance.deserialize_callbacks(callbacks) }.
        to raise_error Mithril::Errors::CallbackError,
        /malformed callbacks hash/ }
      
      specify "raises error with message" do
        begin
          instance.deserialize_callbacks callbacks
        rescue Mithril::Errors::CallbackError => exception
          expect(exception.errors[""]).
            to include_matching(/expected callback not to be nil/i)
        end # begin-rescue
      end # specify
    end # context

    context 'with an invalid controller' do
      let :callbacks do { callback_command => "NotAController" }; end

      specify { expect { instance.deserialize_callbacks(callbacks) }.
        to raise_error Mithril::Errors::CallbackError,
        /malformed callbacks hash/ }

      specify "raises error with message" do
        begin
          instance.deserialize_callbacks callbacks
        rescue Mithril::Errors::CallbackError => exception
          expect(exception.errors[callback_command]).
            to include_matching(/expected controller to extend AbstractController/i)
        end # begin-rescue
      end # specify
    end # context
    
    context 'with an invalid action' do
      let :callbacks do
        { callback_command => "#{callback_controller.name.split("::").last}" };
      end # let

      specify { expect { instance.deserialize_callbacks(callbacks) }.
        to raise_error Mithril::Errors::CallbackError,
        /malformed callbacks hash/ }

      specify "raises error with message" do
        begin
          instance.deserialize_callbacks callbacks
        rescue Mithril::Errors::CallbackError => exception
          expect(exception.errors[callback_command]).
            to include_matching(/expected action not to be nil/i)
        end # begin-rescue
      end # specify
    end # context
    
    context 'with a valid callback' do
      let :callback_actions do
        [].tap do |ary| 3.times do ary << FactoryGirl.generate(:action_key); end; end
      end # let
      
      let :callbacks do
        {}.tap do |hsh|
          callback_actions.each do |action|
            hsh[action.to_s.gsub(/action/, 'command')] =
              "#{callback_controller.to_s.split("::").last},#{action}"
          end # each
        end # tap
      end # let
      
      specify { expect { instance.deserialize_callbacks callbacks }.not_to raise_error }
      
      specify 'reconstructs the serialized callbacks' do
        hsh = instance.deserialize_callbacks callbacks
        
        expect(hsh.keys.sort).to eq callback_actions.map { |action|
          action.to_s.gsub(/action/, 'command').intern
        }.sort
        
        controller = callback_controller.to_s.split("::").last
        callback_actions.each do |action|
          command = action.to_s.gsub(/action/, 'command').intern
          expect(hsh[command][:controller]).to eq callback_controller
          expect(hsh[command][:action]).to eq action
        end # each
      end # specify
    end # context
  end # describe
end # shared examples
