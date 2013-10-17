require 'spec_helper'

describe Comment do
  subject { Comment }
  it 'should respond to ::has_cache' do
    should respond_to(:has_cache)
  end
  it 'should not respond to ::has_cache_options' do
    should_not respond_to(:has_cache_options)
  end
  it 'should not respond to ::cached' do
    should_not respond_to(:cached)
  end
  describe 'instance' do
    subject { Fabricate(:comment) }
    it { should_not respond_to(:cached) }
  end
end
