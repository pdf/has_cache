module HasCache
  # Mixin module to extend ActiveRecord::Base
  module Mixin
    extend ActiveSupport::Concern

    included do
    end

    # Mixin class methods
    module ClassMethods
      def has_cache(*args)
        cattr_accessor :has_cache_options

        options = args.extract_options!
        self.has_cache_options = options

        include HasCache::Mixin::CachedMethod
        extend HasCache::Mixin::CachedMethod
      end
    end

    # Contains the cached method for proxying calls through
    # HasCache::Cache, on both classes and instances.
    module CachedMethod
      def cached(*args)
        HasCache::Cache.new(self, *args)
      end
    end
  end
end

# Add mixin to ActiveRecord::Base
ActiveRecord::Base.send :include, HasCache::Mixin
