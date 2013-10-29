$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'has_cache/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'has_cache'
  s.version     = HasCache::VERSION
  s.authors     = ['Peter Fern']
  s.email       = ['ruby@0xc0dedbad.com']
  s.homepage    = 'http://rubygems.org/gems/has_cache'
  s.summary     = 'Convenience wrapper for the Rails Cache Store'
  s.description = <<-eos
    Using `has_cache` in your classes provides a `cached` method that allows
    automatic caching the result of a method that is normally available on the
    class, or an instance of the class.

    It mitigates the hassle of creating and tracking keys as you would with
    the standard Cache Store interface, by inferring keys from the location
    `cached` is invoked.
  eos

  s.files = Dir[
    '{app,config,db,lib}/**/*',
    'MIT-LICENSE',
    'Rakefile',
    'README.rdoc'
  ]

  s.add_dependency 'rails', '>= 3.1'
  s.add_dependency 'sourcify', '~> 0.5'
  s.add_development_dependency 'rspec-rails', '~> 2.14'
  s.add_development_dependency 'fuubar'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'yard-rails'
  s.add_development_dependency 'yard-blame'
  s.add_development_dependency 'redcarpet'
  s.add_development_dependency 'fabrication'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'listen', '~> 2.1'
  s.add_development_dependency 'guard', '~> 2.0'
  s.add_development_dependency 'guard-rspec', '~> 4.0'
  s.add_development_dependency 'guard-rubocop', '~> 1.0'
end
