# spec/spec_helper.rb

require 'rspec'
require 'factory_girl'

#=# Require Factories, Custom Matchers, &c #=#
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each { |f| require f }

require 'rspec/sleeping_king_studios/matchers/built_in/be_kind_of.rb'
require 'rspec/sleeping_king_studios/matchers/built_in/respond_to.rb'
require 'rspec/sleeping_king_studios/matchers/core/construct.rb'
require 'rspec/sleeping_king_studios/matchers/core/include_matching.rb'

RSpec.configure do |config|
  config.color_enabled = true
end # config
