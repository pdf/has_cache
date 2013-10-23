# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :rspec do
  ignore(%r{^spec/dummy/.*$})
  watch('spec/spec_helper.rb')  { 'spec' }
  watch(%r{^lib/.*\.rb$}) { 'spec' }
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^spec/.+_fabricator\.rb$})
end

guard :rubocop, all_on_start: false do
  ignore(%r{^spec/dummy/.*$})
  watch('spec/spec_helper.rb')
  watch(%r{^lib/.*\.rb$})
  watch(%r{^spec/.*\.rb$})
  watch(%r{^\.rubocop\.yml$})
end
