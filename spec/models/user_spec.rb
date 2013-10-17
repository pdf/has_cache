require 'spec_helper'

describe User do
  subject { User }
  it 'should respond to ::has_cache' do
    should respond_to(:has_cache)
  end
  it 'should respond to ::has_cache_options' do
    should respond_to(:has_cache_options)
  end
  it 'should respond to ::cached' do
    should respond_to(:cached)
  end
  describe 'instance' do
    subject { Fabricate(:user) }
    it { should_not respond_to(:has_cache) }
    it { should respond_to(:cached) }
  end
end
