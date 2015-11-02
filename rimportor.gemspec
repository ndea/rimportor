$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rimportor/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = "rimportor"
  s.version = Rimportor::VERSION
  s.authors = ["Erwin Schens"]
  s.email = ["erwin.schens@qurasoft.de"]
  s.homepage = "TODO"
  s.summary = "Fast, modern and concurrent bulk import for ruby on rails."
  s.description = "Fast, modern and concurrent bulk import for ruby on rails."
  s.license = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency 'rails', '~> 4.2.4'
  s.add_dependency 'parallel', '~> 1.6.0'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails', '~> 3.0.0'
end
