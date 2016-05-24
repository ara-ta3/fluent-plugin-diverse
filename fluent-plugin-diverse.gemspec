# coding: utf-8
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-diverse"
  spec.version       = "0.0.1"
  spec.authors       = ["katzchang"]
  spec.email         = ["katzchang@gmail.com"]

  spec.summary       = "Fluentd output plugin diverse,"
  spec.homepage      = "https://github.com/katzchang/fluent-plugin-diverse"
  spec.license       = "Apache License, Version 2.0"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "test-unit"
  spec.add_runtime_dependency "fluentd"
end
