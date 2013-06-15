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
  
      def maybe
        self
      end
  
      def to_list
        List.new(to_a)
      end
  
      private
      def initialize; end
    end
  end
end
