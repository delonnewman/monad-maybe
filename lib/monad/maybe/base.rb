module Monad
  module Maybe
    class Base
      attr_reader :value

      def <<(obj)
        to_list << obj
      end
  
      def maybe?
        true
      end
  
      def to_list
        List.new(to_a)
      end

      def to_maybe
        self
      end

      def maybe(&blk)
        bind(blk)
      end

      def then(fn)
        bind(->(x){ fn && fn.call })
        self
      end

      def and(&blk)
        self.then(blk)
      end
  
      private_class_method :new
    end
  end
end
