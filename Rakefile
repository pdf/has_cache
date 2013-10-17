begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

# RDoc
require 'rdoc/task'
RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'HasCache'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

# Gems
Bundler::GemHelper.install_tasks

# RuboCop
require 'rubocop/rake_task'
desc 'Run RuboCop on the lib directory'
Rubocop::RakeTask.new(:rubocop) do |task|
  task.patterns = ['lib/**/*.rb']
  # don't abort rake on failure
  task.fail_on_error = false
end

# RSpec
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task default: :spec
