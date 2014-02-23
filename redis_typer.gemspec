# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redis_typer/version'

Gem::Specification.new do |spec|
  spec.name          = "redis_typer"
  spec.version       = RedisTyper::VERSION
  spec.authors       = ["Kostiantyn Kahanskyi"]
  spec.email         = ["kostiantyn.kahanskyi@googlemail.com"]
  spec.description   = %q{Experimental implementation of a Redis wrapper in Ruby}
  spec.summary       = %q{Experimental implementation of a Redis wrapper in Ruby}
  spec.homepage      = "https://github.com/kostia/redis_typer"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
