# spec/spec_helper.rb

require 'rspec'
require 'factory_girl'

#=# Require Factories, Custom Matchers, &c #=#
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.color_enabled = true
  config.include(Mithril::Support::Matchers)
end # config
