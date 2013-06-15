module Monad
  module Maybe
    class List
      include Enumerable
  
      def initialize(enum)
        @enum = enum.map { |v| v.maybe? ? v : v.maybe }
      end
  
      def inspect
        "#{to_a}"
      end
  
      def maybe?
        true
      end
  
      def <<(obj)
        @enum << obj if obj.just?
        self
      end
  
      def to_a
        @enum.to_a
      end
  
      def to_maybe
        first.maybe
      end
  
      def each
        @enum.each do |x|
          yield(x)
        end
      end
  
      def map
        e = []
        each do |x|
          e << yield(x)
        end
        List.new(e)
      end
      alias maybe_map map
  
      def select
        e = []
        each do |x|
          is_true = yield(x)
          e << x if is_true  
        end
        List.new(e)
      end
  
      def reject
        select { |x| !yield(x) }
      end
  
      def select_just
        select { |x| x.just? }
      end
  
      def unwrap_map(default, &blk)
        to_a.map { |x| blk ? blk.call(x.unwrap(default)) : x.unwrap(default) }
      end
  
      def value_map(&blk)
        to_a.map { |x| blk ? blk.call(x.value) : x.value }
      end
    end
  end
end
