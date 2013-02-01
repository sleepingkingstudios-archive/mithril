# spec/support/factories/request_factory.rb

require 'factory_girl'

require 'mithril/request'

FactoryGirl.define do
  factory :request, class: Mithril::Request do
    session { Hash.new }
  end # factory
end # define
