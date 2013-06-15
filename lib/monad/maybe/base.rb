module Monad
  module Maybe
    class Base
      def self.create(val)
        (val.nil? && Nothing.instance.freeze) || Just.new(val)
      end
  
      def <<(obj)
        to_list << obj
      end
  
      def maybe?
        true
      end
  
      def to_maybe
        self
      end
      alias maybe to_maybe
  
      def to_list
        List.new(to_a)
      end
  
      private
      def initialize; end
    end
  end
end
