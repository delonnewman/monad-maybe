require_relative 'base'

module Monad
  module Maybe
    #
    # A better nil
    #
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
  
      def just?
        false
      end
  
      def unwrap(val)
        val
      end
  
      def value
        nil
      end
  
      def to_json(*args)
        'null'
      end
  
      # collection methods
  
      def to_a
        []
      end
  
      def to_h
        {}
      end
  
      # comparison methods
      
      def equal?(other)
        other == instance
      end
  
      def ==(other)
        other == nil || other.class == Nothing || other == Nothing
      end
  
      def ===(other)
        other == instance
      end
  
      def <=>(other)
        nil <=> other
      end
  
      def <(other)
        other.is_a?(String) ? to_s < other : to_i < other
      end
  
      def <=(other)
        if self == other then true
        else
          other.is_a?(String) ? to_s <= other : to_i <= other
        end
      end
  
      def >(other)
        other.is_a?(String) ? to_s > other : to_i > other
      end
  
      def >=(other)
        if self == other then true
        else
          other.is_a?(String) ? to_s >= other : to_i >= other
        end
      end
  
      # logical methods, evaluates to false
  
      def |(other)
        other.nil? || other == false ? false : true
      end
  
      def &(other)
        false
      end
  
      def ^(other)
        other.nil? || other == false ? false : true
      end
  
      def !
        true
      end
  
      # numerical methods, evaluates to 0 or equivalent
      # string methods, evaluates to ''
      
      def to_s
        ''
      end
      alias to_str to_s
  
      def to_i
        0
      end
      alias to_int to_i
  
      def to_f
        0.0
      end
  
      def to_r
        0.to_r
      end
  
      def to_c
        0.to_c
      end
  
      def rationalize(*args)
        to_r
      end
  
      def -@
        0
      end
  
      def +(other)
        other.is_a?(String) ? other : other
      end
  
      def -(other)
        0 - other
      end
  
      def *(other)
        other.is_a?(String) ? '' : 0
      end
  
      def **(other)
        0
      end
    end
  end
end
