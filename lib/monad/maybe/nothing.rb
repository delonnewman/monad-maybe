require 'singleton'

module Monad
  module Maybe
    class Nothing < Base
      include ::Singleton
  
      def method_missing(method, *args)
        self
      end
  
      def clone
        self
      end
  
      def inspect
        'nothing'
      end
  
      def nil?
        true
      end
  
      def nothing?
        true
      end
  
      def bind(fn)
        self
      end

      def just?
        false
      end

      def something?
        false
      end
  
      def unwrap(val)
        val
      end
  
      def value
        nil
      end
  
      def to_s
        ''
      end
      alias to_str to_s

      def to_a
        []
      end
    end
  end
end
