# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cigale/version'

Gem::Specification.new do |spec|
  spec.name          = "cigale"
  spec.version       = Cigale::VERSION
  spec.authors       = ["Amos Wenger"]
  spec.email         = ["fasterthanlime@gmail.com"]
  spec.summary       = %q{Jenkins job generator}
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ["cigale"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.8"
  spec.add_development_dependency "minitest-reporters", "~> 1.1.7"
  spec.add_runtime_dependency "slop", "~> 4.2.1"
  spec.add_runtime_dependency "builder", "~> 3.2.2"
end
