require 'json'

#
# Adds JSON conversions to Just, Nothing, and List
#
module Monad
  module Maybe
    class Just
      def to_json(*args)
        value.to_json(*args)
      end
    end

    class Nothing
      def to_json(*args)
        'null'
      end
    end

    class List
      def to_json(*args)
        to_a.to_json(*args)
      end
    end
  end
end
