lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "master_crypt/version"

Gem::Specification.new do |spec|
  spec.name = "master-crypt"
  spec.version = MasterCrypt::VERSION
  spec.authors = ["Cian McElhinney"]

  spec.license = "MIT"

  spec.summary = "Encrypting data with multiple keys"
  spec.description = "Allows for encrypting a single piece of data with multiple keys which can each be used to decrypt it"
  spec.homepage = "https://github.com/cianmce/master-crypt"

  spec.files = Dir["README.md", "lib/**/*"]
  spec.bindir = "bin"
  spec.executables = Dir["bin/*"].map { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.3.0"

  spec.add_development_dependency "standardrb", "~> 1.0"
  spec.add_development_dependency "bundler", ">= 0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.10"
  spec.add_development_dependency "pry", "~> 0.13.0"
  spec.add_development_dependency "pry-byebug", "~> 3.9"
  spec.add_development_dependency "pry-doc", "~> 1.1"
  spec.add_development_dependency "guard", "~> 2.18"
  spec.add_development_dependency "guard-rspec", "~> 4.7.3"
  spec.add_dependency "rbnacl", "7.1.1"
end
