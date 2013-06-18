require 'test/unit'
require_relative '../lib/monad'

class MonadTest < Test::Unit::TestCase
  class M
    include Monad
  end

  def setup
    @m = M.return(1)
    @f = ->(x) { M.return(x) }
    @g = ->(x) { x + 1 }
  end

  #
  # In Haskell:
  #    m >> return = m
  #
  def test_right_unit
    assert_equal @m, @m.bind(->(v) { M.return(v) })
    assert_equal @m, @m.unwrap { |v| M.return(v) }
  end

  #
  # In Haskell:
  #    return x >> f = f x
  #
  def test_left_unit
    assert_equal @f[1], @m.bind(@f)
  end

  #
  # In Haskell:
  #    (m >>= f) >>= g = m >>= (\x -> f x >>= g)
  #
  def test_bind_associativity
    assert_equal @m.bind(@f).bind(@g), @m.bind(->(x) { @f[x].bind(@g) })
  end
end
