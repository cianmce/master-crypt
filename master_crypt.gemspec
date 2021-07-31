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

  spec.add_development_dependency "standardrb", "~> 1.0"
  spec.add_development_dependency "bundler", "~> 2.2"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.10"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "pry-doc"
  spec.add_dependency "rbnacl", "7.1.1"
end
