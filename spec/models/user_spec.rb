require 'spec_helper'
require 'sourcify'

describe User do
  subject(:user) { User }

  it 'should respond to ::has_cache' do
    should respond_to(:has_cache)
  end
  it 'should respond to ::has_cache_options' do
    should respond_to(:has_cache_options)
  end
  it 'should respond to ::cached' do
    should respond_to(:cached)
  end
  it 'should have cache options' do
    expect(user.has_cache_options).to eq(expires_in: 1.day)
  end

  describe '::cached' do
    before { Fabricate.times(3, :user) }

    describe 'without arguments' do
      describe 'with method' do
        describe 'without arguments' do
          subject!(:cached) { User.cached.all }

          it 'should create a cache' do
            key = %w{User class all}
            expect(Rails.cache.exist?(key)).to be_true
          end
          it 'should load the results' do
            expect(cached.loaded?).to be_true
          end
          it 'should cache the correct results' do
            should have(3).item
            should eq(User.all)
          end
        end

        describe 'with arguments' do
          subject!(:cached) { User.cached.find(user.id) }
          let(:user) { User.first }

          it 'should create a cache' do
            key = ['User', 'class', 'find', user.id]
            expect(Rails.cache.exist?(key)).to be_true
          end
          it 'should cache the correct results' do
            should eq(user)
          end
        end

        it 'delivers correct arguments to the cache' do
          key = ['User', :class, :all]
          expect(Rails.cache).to receive(:fetch).with(
            key,
            { expires_in: 1.day }
          )
          User.cached.all
        end
      end
    end

    describe 'with arguments' do
      describe 'with method' do
        it 'delivers correct arguments to the cache' do
          key = ['User', :class, :all]
          expect(Rails.cache).to receive(:fetch).with(
            key,
            { expires_in: 1.week }
          )
          User.cached(expires_in: 1.week).all
        end
      end
    end
  end

  describe 'instance' do
    subject(:user) { Fabricate(:user) }

    it { should_not respond_to(:has_cache) }
    it { should respond_to(:cached) }

    describe '#cached' do
      let(:user) { Fabricate(:user) }
      before { Fabricate.times(3, :article, user_id: user.id) }

      describe 'without arguments' do
        describe 'with method' do
          subject!(:cached) { user.cached.articles }

          it 'should create a cache' do
            key = ['User', 'instance', user.id, 'articles']
            expect(Rails.cache.exist?(key)).to be_true
          end
          it 'should load the results' do
            expect(cached.loaded?).to be_true
          end
          it 'should cache the correct results' do
            should have(3).item
            should eq(user.articles)
          end
        end

        describe 'with block' do
          subject!(:cached) do
            user.cached { articles.where(id: 1) }
          end
          let(:article) { user.articles.find(1) }

          it 'should create a cache' do
            proc_source = lambda { articles.where(id: 1) }.to_source
            key = ['User', 'instance', user.id, proc_source]
            expect(Rails.cache.exist?(key)).to be_true
          end
          it 'should load the results' do
            expect(cached.loaded?).to be_true
          end
          it 'should cache the correct results' do
            should have(1).item
            should eq([article])
          end
        end

        it 'delivers correct arguments to the cache' do
          key = ['User', :instance, 1, :articles]
          expect(Rails.cache).to receive(:fetch).with(
            key,
            { expires_in: 1.day }
          )
          user.cached.articles
        end
      end
    end

    describe 'with arguments' do
      describe 'with method' do
        it 'delivers correct arguments to the cache' do
          key = ['User', :instance, 1, :articles]
          expect(Rails.cache).to receive(:fetch).with(
            key,
            { expires_in: 1.week }
          )
          user.cached(expires_in: 1.week).articles
        end
      end
    end
  end
end
