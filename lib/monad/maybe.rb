require_relative 'maybe/base'
require_relative 'maybe/just'
require_relative 'maybe/nothing'
require_relative 'maybe/list'

module Monad
  module Maybe
    module Enumerable
      def to_maybe
        Base.create(first)
      end
  
      def maybe_map
        List.new(map{ |x| yield(x) })
      end
    end
  
    class ::Array; include Enumerable end
    class ::Range; include Enumerable end
  
    class ::Object
      def to_maybe
        Base.create(self)
      end
      alias maybe to_maybe
  
      def maybe?
        false
      end
  
      def just?
        false
      end
  
      def nothing?
        false
      end
    end
  end
end

include Monad::Maybe
