module Monad
  module Maybe
    class Just < Base
      def initialize(value)
        @value = value
      end
  
      def method_missing(method, *args)
        value.send(method, *args).maybe
      end
  
      def unwrap(val)
        value
      end
  
      def nothing?
        false
      end

      def something?
        true
      end
  
      def just?
        true
      end

      # NOTE: being able to return Nothings maybe dangerous
      def maybe(&blk)
        if blk
          blk.call(self.value).to_maybe
        else
          self
        end
      end
  
      def nil?
        false
      end
  
      def ==(other)
        self === other || self.value == other
      end
  
      def ===(other)
        other.just? && self.value == other.value
      end
  
      def equal?(other)
        other.__id__ == self.__id__
      end
  
      def inspect
        "just(#{value.inspect})"
      end

      def to_s
        value.to_s
      end
      alias to_str to_s
  
      def to_a
        [self]
      end
    end
  end
end
