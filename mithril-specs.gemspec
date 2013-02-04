# mithril-specs.gemspec

require File.expand_path("../lib/mithril/version", __FILE__)

Gem::Specification.new do |mithril_specs|
  mithril_specs.name         = 'mithril-specs'
  mithril_specs.version      = Mithril::VERSION
  mithril_specs.summary      = 'Mithril spec helpers'
  mithril_specs.description  = 'Spec helpers for the Mithril interactive text engine'
  mithril_specs.authors      = ['Rob "Merlin" Smith']
  mithril_specs.email        = 'merlin@sleepingkingstudios.com'
  mithril_specs.homepage     = 'http://sleepingkingstudios.com'
  
  mithril_specs.require_path = 'spec'
  mithril_specs.files        = Dir["spec/**/*_helper.rb", "spec/support/**/*.rb", "LICENSE", "*.md"]
  
  mithril_specs.add_development_dependency 'mithril', Mithril::VERSION
  mithril_specs.add_development_dependency 'rspec', '~> 2.12'
  mithril_specs.add_development_dependency 'factory_girl', '~> 4.2'
end # gem specification
