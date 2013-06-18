module Functor
  class Base
    def fmap(&blk)
    end
  end
end

#
# Monad laws
#
# 1) Right unit
#
#   In Haskell:
#     m >>= return = m
#
#   In Ruby:
#     m.bind { |v| v.return } = m 
#
# 2) Left unit
#
#   In Haskell:
#     return x >>= f = f x
#
#   In Ruby:
#     x.return.bind { |v| 
#
# 3) Associativity
#
#   In Haskell:
#     (m >>= f) >>= g = m >>= (\x -> f x >>= g)
#
#   In Ruby
#

module Monad
  class Base < Functor::Base
    def wrap(value)
      new(value)
    end
    alias return wrap

    def unwrap(&blk)
    end
    alias bind unwrap

    def then(&blk)
      unwrap do
        blk.call
      end
    end

    private
    def initialize(value)
      @value = value
    end
  end
end

