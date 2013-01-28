# mithril.gemspec

require File.expand_path("../lib/mithril/version", __FILE__)

Gem::Specification.new do |mithril|
  mithril.name         = 'mithril'
  mithril.version      = Mithril::VERSION
  mithril.summary      = 'An interactive text engine'
  mithril.description  = 'An interactive text engine'
  mithril.authors      = ['Rob "Merlin" Smith']
  mithril.email        = 'merlin@sleepingkingstudios.com'
  mithril.homepage     = 'http://sleepingkingstudios.com'
  
  mithril.require_path = 'lib'
  mithril.files        = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  mithril.executables  << 'mithril'
  
  mithril.add_development_dependency 'rspec', '~> 2.12'
  mithril.test_files   = Dir.glob("spec/**/*.rb")
end # gem specification
