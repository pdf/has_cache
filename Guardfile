# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :rspec do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^fabricators/.+_fabricator\.rb$})
  watch('spec/spec_helper.rb')  { 'spec' }
end

=begin
guard :rubocop, cli: ['lib/**/*.rb', 'spec/spec_helper.rb', 'spec/*/*.rb'] do
  watch('lib/**/*.rb')
  watch('spec/spec_helper.rb')
  watch('spec/*/*.rb')
  watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
end
=end
