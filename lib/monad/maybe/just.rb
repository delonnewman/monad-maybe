module Monad
  module Maybe
    #
    # Wraps a non-nil object allows us to treat these
    # objects as a Maybe while distinguishing them from
    # a Nothing
    #
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

      # NOTE: This being able to return Nothings maybe dangerous
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
        Just.new(value.to_s)
      end
  
      def to_a
        [self]
      end
    end
  end
end
