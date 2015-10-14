# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "carrierwave/sequel/version"

Gem::Specification.new do |s|
  s.name        = "carrierwave-sequel"
  s.version     = Carrierwave::Sequel::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jonas Nicklas", "Trevor Turk"]
  s.email       = ["jonas.nicklas@gmail.com"]
  s.homepage    = "https://github.com/jnicklas/carrierwave-sequel"
  s.summary     = %q{Sequel support for CarrierWave}
  s.description = %q{Sequel support for CarrierWave}

  s.rubyforge_project = "carrierwave-sequel"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "carrierwave"
  s.add_dependency "sequel"
  s.add_development_dependency "rspec", ["~> 2.14.1"]
  s.add_development_dependency "sqlite3"
end
