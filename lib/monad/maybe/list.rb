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
        Base.create(first)
      end
      alias maybe to_maybe
  
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
  
      def unwrap_map(default)
        to_a.map { |x| x.unwrap(default) }
      end
  
      def select_just_map_value
        select_just.value_map
      end
  
      def value_map
        to_a.map { |x| x.value }
      end
    end
  end
end
