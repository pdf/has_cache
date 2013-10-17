begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

# Yard
require 'yard'
YARD::Rake::YardocTask.new do |t|
  t.files   = %w{lib/**/*.rb}
  t.options = %w{--protected --private --readme README.md --files README.md,CONTRIBUTING.md}
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
