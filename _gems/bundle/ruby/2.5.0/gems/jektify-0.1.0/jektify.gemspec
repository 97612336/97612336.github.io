
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jektify/version"

Gem::Specification.new do |spec|
  spec.name          = "jektify"
  spec.version       = Jektify::VERSION
  spec.authors       = ["William Canin"]
  spec.email         = ["william.costa.canin@gmail.com"]

  spec.summary       = %q{Jekyll plugin to generate HTML code fragments to incorporate music from Spotify}
  spec.homepage      = "https://github.com/williamcanin/jektify"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|pkg)}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
