module Functor
  def fmap(fn)
  end

  def join
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
#     m.bind ->(v) { |v| v.return } = m 
#
# 2) Left unit
#
#   In Haskell:
#     return x >>= f = f x
#
#   In Ruby:
#     x.return.bind(f) = f[x]  
#
# 3) Associativity
#
#   In Haskell:
#     (m >>= f) >>= g = m >>= (\x -> f x >>= g)
#
#   In Ruby
#     m.bind(f).bind(g) = m.bind ->(x) { f[x].bind(g) }
#

module Monad
  class << self
    def included(klass)
      klass.extend(ClassMethods)
    end
  end

  module ClassMethods
    def return(value)
      new(value)
    end
    alias wrap return
  end

  def bind(fn)
    fn[@value]
  end

  def unwrap(&blk)
    bind(blk)
  end

  def then(fn)
    bind(->(x){ fn.call })
    self
  end

  def ==(other)
    other.is_a?(Monad) && other.bind(->(x) { x == @value })
  end

  private
  def initialize(value)
    @value = value
  end
end

