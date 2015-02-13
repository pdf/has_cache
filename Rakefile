begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

# Yard
ENV['YARD_USER'] = 'pdf'
ENV['YARD_PROJECT'] = 'has_cache'
require 'yard'
require 'yard-rails'
require 'yard-blame'
YARD::Rake::YardocTask.new do |t|
  t.files   = %w(lib/**/*.rb)
  t.options = %w(--protected --private --readme README.md
                 --markup markdown --markup-provider redcarpet
                 --plugin rails --plugin blame
                 --files README.md,CONTRIBUTING.md)
end

# Gems
Bundler::GemHelper.install_tasks

# RuboCop
require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop)

# RSpec
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task doc: :yard
task default: :spec
