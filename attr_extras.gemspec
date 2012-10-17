# -*- encoding: utf-8 -*-
require File.expand_path('../lib/attr_extras/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Henrik Nyh"]
  gem.email         = ["henrik@nyh.se"]
  gem.summary       = %q{Adds attr_initialize and attr_private methods.}
  gem.homepage      = "https://github.com/barsoom/attr_extras"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "attr_extras"
  gem.require_paths = ["lib"]
  gem.version       = AttrExtras::VERSION

  if RUBY_VERSION < "1.9.3"
    gem.add_development_dependency "minitest"
  end
end
