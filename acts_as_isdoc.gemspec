# -*- encoding: utf-8 -*-
require File.expand_path('../lib/acts_as_isdoc/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jiri Kubicek"]
  gem.email         = ["jiri.kubicek@kraxnet.cz"]
  gem.description   = %q{Rendering business objects in ISDOC format}
  gem.summary       = %q{Business objects in ISDOC format}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "acts_as_isdoc"
  gem.require_paths = ["lib"]
  gem.version       = ActsAsIsdoc::VERSION

  gem.add_dependency "builder"
  gem.add_dependency "htmlentities"
end
