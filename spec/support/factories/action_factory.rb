# spec/factories/action_factory.rb

require 'factory_girl'

FactoryGirl.define do
  sequence :action_key do |index| "action_#{index}"; end
end # define
