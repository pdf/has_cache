module HasCache
  # Container for utility methods
  module Utilities
    def extract_result(result)
      if result.is_a?(ActiveRecord::Relation)
        if result.respond_to?(:load) &&
           result.method(:load).owner == ActiveRecord::Relation
          result.load
        elsif result.respond_to?(:to_a)
          result.to_a
        end
      end
      result
    end

    def merged_options(target, local_options)
      if target.is_a?(Class)
        class_options = target.has_cache_options
      else
        class_options = target.class.has_cache_options
      end
      class_options.delete(:key) if target.respond_to?(:has_cache_key)
      class_options.merge(local_options)
    end
  end
end
