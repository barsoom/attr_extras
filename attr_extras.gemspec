# -*- encoding: utf-8 -*-
require File.expand_path("../lib/attr_extras/version", __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Henrik Nyh", "Joakim Kolsjö", "Tomas Skogberg", "Victor Arias", "Ola K"]
  gem.email         = ["henrik@nyh.se"]
  gem.summary       = %q{Takes some boilerplate out of Ruby with methods like attr_initialize.}
  gem.homepage      = "https://github.com/barsoom/attr_extras"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "attr_extras"
  gem.require_paths = ["lib"]
  gem.license       = "MIT"
  gem.version       = AttrExtras::VERSION
  gem.metadata       = { "rubygems_mfa_required" => "true" }

  gem.add_development_dependency "minitest", ">= 5"
  gem.add_development_dependency "m", "~> 1.5.1"  # Running individual tests.

  # For Travis CI.
  gem.add_development_dependency "rake"
end
