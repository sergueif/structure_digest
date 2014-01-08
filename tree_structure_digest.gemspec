# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tree_structure_digest/version'

Gem::Specification.new do |spec|
  spec.name          = "tree_structure_digest"
  spec.version       = TreeStructureDigest::VERSION
  spec.authors       = ["Serguei Filimonov"]
  spec.email         = ["serguei.filimonov@gmail.com"]
  spec.description   = %q{Digests and lists all the paths through a nested dictionary}
  spec.summary       = %q{run the binary on YAML files to check it out}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
