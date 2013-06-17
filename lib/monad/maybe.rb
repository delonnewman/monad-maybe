require_relative 'maybe/base'
require_relative 'maybe/just'
require_relative 'maybe/nothing'
require_relative 'maybe/list'

# Top-level module includes some monkey patching and
# constructor methods.  Monad::Maybe is included by default.
module Monad
  module Maybe
    module Enumerable
      def to_maybe
        first.maybe
      end
  
      def maybe_map
        List.new(map{ |x| yield(x) })
      end
    end
  
    class ::Array; include Enumerable end
    class ::Range; include Enumerable end
  
    class ::Object
      def maybe
        Just.new(self)
      end
  
      def maybe?
        false
      end
  
      def just?
        false
      end
  
      def nothing?
        false
      end

      def something?(&blk)
        blk.call(self) if blk
        true
      end
    end

    class ::NilClass
      def maybe
        Nothing.instance.freeze
      end
    end

    def maybe(o)
      o.maybe
    end

    def just(o)
      Just.new(o)
    end

    def nothing
      Nothing.instance
    end
  end
end

include Monad::Maybe
