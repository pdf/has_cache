require 'sourcify'

module HasCache
  # The cache class proxies calls to the original target, caching the results,
  # and returns the cached results if passed the same target and arguments
  class Cache
    extend HasCache::Utilities
    include HasCache::Utilities

    attr_accessor :target, :cache_root, :cache_options

    def self.new(*args, &block)
      o = allocate
      o.__send__(:initialize, *args, &block)
      return o unless block_given?

      key = o.generate_key
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
      Rails.cache.fetch(key, o.cache_options) do
        if o.target.is_a?(Class)
          result = o.target.class_eval(&block)
        else
          result = o.target.instance_eval(&block)
        end
        extract_result(result)
      end
    end

    def initialize(target, options = {})
      @target = target
      @cache_root = []
      @cache_options = merged_options(target, options)
      if target.is_a?(Class)
        @cache_root = [target.name, :class]
      else
        @cache_root = [target.class.name, :instance]
        unless target.respond_to?(:has_cache_key)
          if target.class.respond_to?(:primary_key)
            @cache_root << target.send(target.class.send(:primary_key).to_sym)
          elsif target.respond_to?(:id)
            @cache_root << target.send(:id)
          elsif target.respond_to?(:name)
            @cache_root << target.send(:name)
          else
            # rubocop:disable LineLength, StringLiterals
            fail ArgumentError, "Could not find key for instance of `#{target.class.name}`, must call with `instance.cached(key: some_unique_key).method`"
            # rubocop:enable LineLength, StringLiterals
          end
        end
      end
    end

    def generate_key
      key = cache_root
      if cache_options.key?(:key)
        options_key = cache_options.delete(:key)
        if options_key.is_a?(Proc)
          if target.is_a?(Class)
            key += Array.wrap(target.class_eval(&options_key))
          else
            key += Array.wrap(target.instance_eval(&options_key))
          end
        else
          key += Array.wrap(options_key)
        end
      elsif target.respond_to?(:has_cache_key)
        key += target.send(:has_cache_key)
      end
      key
    end

    private

      def method_missing(method, *args)
        key = generate_key
        unless cache_options.delete(:canonical_key)
          key += [method]
          key += args unless args.empty?
        end
        Rails.cache.fetch(key, cache_options) do
          extract_result(target.send(method, *args))
        end
      end

      def respond_to?(method)
        target.respond_to?(method)
      end
  end
end
