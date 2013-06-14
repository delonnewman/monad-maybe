require 'singleton'

module Dragnet
  module Utils

    private

    module Maybe
      def <<(obj)
        to_list << obj
      end
    end

    class MaybeList
      include Enumerable

      def self.create(obj=nil)
        if obj.is_a?(Just)
          MaybeList.new(obj)
        else
          MaybeList.new
        end
      end

      def initialize(obj)
        @list = []
        self << obj
      end

      def inspect
        "[#{@list.to_a.join(', ')}]"
      end

      def <<(obj)
        @list << obj if obj.is_a?(Just)
        self
      end

      def each
        @list.each do |x|
          yield x
        end
      end
    end

    class Just
      include Maybe

      def initialize(&blk)
        @blk = blk
      end

      def call
        @value ||= @blk.call
      end
      alias from_just call
      alias to_obj call

      def from_maybe(val)
        from_just
      end
      alias unwrap from_maybe

      def nothing?
        false
      end

      def just?
        true
      end

      def maybe?
        true
      end

      def nil?
        false
      end

      def ==(other)
        other.is_a?(Just) ? call == other.call : false 
      end

      def equal?(other)
        other.__id__ == self.__id__
      end
      alias === equal?

      def is_a?(klass)
        klass == Maybe or klass == Just or klass == BasicObject
      end
      alias kind_of? is_a?

      def inspect
        "just(#{call.inspect})"
      end

      def to_s
        inspect
      end

      def to_a
        [self]
      end

      def to_list
        MaybeList.new(self)
      end

      def to_json(*args)
        call.to_json
      end

      def class
        Just
      end
    end

    class Nothing
      include Maybe
      include ::Singleton

      def method_missing(method, *args)
        self
      end

      def inspect
        'nothing'
      end

      def to_s
        ''
      end

      def nil?
        true
      end

      def nothing?
        true
      end

      def just?
        false
      end

      def maybe?
        true
      end

      def from_maybe(val)
        val
      end
      alias unwrap from_maybe

      def to_json(*args)
        'null'
      end

      def to_list
        MaybeList.new
      end

      def to_a
        []
      end

      def ==(other)
        other == nil || other.class == Nothing || other == Nothing
      end

      def ===(other)
        other == instance
      end

      def class
        Nothing
      end

      def equal?(other)
        other == instance
      end

      def instance_of?(klass)
        klass == Nothing
      end

      def is_a?(klass)
        klass == Maybe or klass == Nothing or klass == Object
      end
      alias kind_of? is_a?

      def clone
        self
      end
    end

    public

    def maybe(default=nil, &blk)
      m = ((val = blk.call).nil? && Nothing.instance) || Just.new{ val }
      default ? m.from_maybe(default) : m
    end

    module Enumerable
      def to_maybe
        maybe{ first }
      end

      def cat_maybes
        select { |x| x.just? }
      end

      def map_maybe(default=nil)
        xs = map do |x|
          maybe(default){ yield x }
        end
        default ? xs : xs.cat_maybes
      end
    end

    class ::Array; include Enumerable; end
    class ::Range; include Enumerable; end
    class ::Enumerator::Lazy; include Enumerable; end
  end
end

