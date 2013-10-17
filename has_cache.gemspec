$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'has_cache/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'has_cache'
  s.version     = HasCache::VERSION
  s.authors     = ['Peter Fern']
  s.email       = ['ruby@0xc0dedbad.com']
  s.homepage    = 'http://rubygems.org/gems/has_cache'
  s.summary     = 'Adds easy to access Rails caching to any class'
  s.description = 'Using `has_cache` in your classes provides a `cached` method that allows chaining of a method that is normally available on the class, and automatically caching the result.'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']

  s.add_dependency 'rails', '>= 3.1'
  s.add_development_dependency 'rspec-rails', '~> 2.14'
  s.add_development_dependency 'rubocop'
end
