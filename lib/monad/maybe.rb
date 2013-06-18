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
      def maybe(obj=self, &blk)
        if obj && blk
          blk.call(obj).to_maybe
        else
          obj.to_maybe
        end
      end

      def to_maybe
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
        true
      end
    end

    class ::NilClass
      def to_maybe
        Nothing.instance.freeze
      end

      def maybe(&blk)
        to_maybe
      end

      def something?
        false
      end
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
