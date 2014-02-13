require 'sourcify'

module HasCache
  # The cache class proxies calls to the original cache_target, caching the
  # results, and returns the cached results if passed the same cache_target
  # and arguments
  class Cache
    extend HasCache::Utilities
    include HasCache::Utilities

    attr_accessor :cache_target, :cache_root, :cache_options

    def self.new(*args, &block)
      o = allocate
      o.__send__(:initialize, *args, &block)
      return o unless block_given?

      key = o.cache_key
      begin
        block_source = block.to_source(ignore_nested: true)
      rescue => e
        if key == o.cache_root
          # rubocop:disable LineLength, StringLiterals
          raise ArgumentError, "Could not generate key from block, must call with `.cached(key: some_unique_key) { block }` (#{e})"
          # rubocop:enable LineLength, StringLiterals
        end
      end
      unless o.cache_options.delete(:canonical_key) || block_source.nil?
        key += [block_source]
      end
      if o.cache_options.delete(:delete)
        Rails.cache.delete(key)
      else
        Rails.cache.fetch(key, o.cache_options) do
          if o.cache_target.is_a?(Class)
            extract_result(o.cache_target.class_eval(&block))
          else
            extract_result(o.cache_target.instance_eval(&block))
          end
        end
      end
    end

    def initialize(cache_target, options = {})
      @cache_target = cache_target
      @cache_root = []
      @cache_options = merged_options(cache_target, options)
      if cache_target.is_a?(Class)
        @cache_root = [cache_target.name, :class]
      else
        @cache_root = [cache_target.class.name, :instance]

        return if cache_target.respond_to?(:has_cache_key)

        if cache_target.class.respond_to?(:primary_key)
          primary_key = cache_target.class.send(:primary_key)

          # Support composite primary keys
          # TODO: spec this
          case primary_key
          when String
            @cache_root << cache_target.send(primary_key.to_sym)
          when Array
            @cache_root << primary_key.map { |k| cache_target.send(k.to_sym) }
          else
            fail "Unknown primary key type: #{primary_key.class}"
          end
        elsif cache_target.respond_to?(:id)
          @cache_root << cache_target.send(:id)
        elsif cache_target.respond_to?(:name)
          @cache_root << cache_target.send(:name)
        else
          # rubocop:disable LineLength, StringLiterals
          fail ArgumentError, "Could not find key for instance of `#{cache_target.class.name}`, must call with `instance.cached(key: some_unique_key).method`"
          # rubocop:enable LineLength, StringLiterals
        end
      end
    end

    def cache_key
      key = cache_root
      if cache_options.key?(:key)
        options_key = cache_options.delete(:key)
        if options_key.is_a?(Proc)
          if cache_target.is_a?(Class)
            key += Array.wrap(cache_target.class_eval(&options_key))
          else
            key += Array.wrap(cache_target.instance_eval(&options_key))
          end
        else
          key += Array.wrap(options_key)
        end
      elsif cache_target.respond_to?(:has_cache_key)
        key += cache_target.send(:has_cache_key)
      end
      key
    end

    private

      def method_missing(method, *args)
        key = cache_key
        unless cache_options.delete(:canonical_key)
          key += [method]
          key += args unless args.empty?
        end
        if cache_options.delete(:delete)
          Rails.cache.delete(key)
        else
          Rails.cache.fetch(key, cache_options) do
            extract_result(cache_target.send(method, *args))
          end
        end
      end

      def respond_to?(method)
        cache_target.respond_to?(method)
      end
  end
end
