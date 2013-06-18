module Monad
  module Either
    class Base
      attr_reader :value

      def initialize(value)
        @value = value
      end

      def either?
        true
      end
    end

    class Left < Base
      def left?
        true
      end
    end

    class Right < Base
      def right?
        true
      end
    end

    def either(either)
      yield
      @right.call(either.value) if either.right?
      @left.call(either.value) if either.left?
    end

    def right(&blk)
      @right = blk
    end

    def left(&blk)
      @left = blk
    end
  end

  class ::Object
    def left?
      false
    end

    def either?
      false
    end

    def right?
      false
    end
  end
end

include Monad::Either

either(Left.new(1)) do
  left do |value|
    puts "It's left: #{value}"
  end

  right do |value|
    puts "It's right: #{value}"
  end
end
