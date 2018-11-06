require 'test/unit'
require_relative '../lib/monad/maybe'
require_relative '../lib/monad/maybe/json'

class MaybeTest < Test::Unit::TestCase
  def test_nothing
    assert nil.to_maybe.nothing?
    assert nil.to_maybe.value.nil?
    assert_equal 'test', nil.to_maybe.unwrap('test')
    assert_equal '', nothing.to_s
  end

  def test_just
    assert maybe(1).just?
    assert_equal 1, 1.to_maybe.value
    assert_equal 1, 1.to_maybe.unwrap('test')
    assert_equal '1', just(1).to_s
  end

  def test_json
    assert_equal 'null', nothing.to_json
    assert_equal '1', just(1).to_json
    assert_equal '{}', just({}).to_json
    assert_equal '[]', just([]).to_json
    assert_equal (0..10).to_a.to_json, (0..10).maybe_map { |n| n }.to_json
  end

  def test_to_a
    assert_equal [1.to_maybe], 1.to_maybe.to_a
    assert_equal [], nil.to_maybe.to_a
  end

  def test_false
    assert_equal false, false.to_maybe.value
  end

  def test_nil_conversions
    assert_equal nil.nil?, nil.to_maybe.nil?
  end

  def test_class
    assert_equal Monad::Maybe::Nothing, maybe(nil).class
    assert_equal Monad::Maybe::Just, maybe(1).class
  end

  def test_list
    xs = true.to_maybe << nil.to_maybe << 1.to_maybe << 3.to_maybe
    assert_equal 3, xs.count
    xs.each { |x| assert x.just? }
  end

  def test_enumerable
    assert_nothing_raised do
      xs = (0..10).select { |n| n % 2 != 0 }
      ys = (0..10).maybe_map { |n| n % 2 == 0 ? nil : n }.select_just.value_map
      assert_equal xs.count, ys.count
    end
  end

  def test_maybe_block
    assert_nothing_raised do
      nothing.maybe do
        raise Exception, "This should not be called"
      end
    end

    assert_nothing_raised do
      maybe(nil) do
        raise Exception, "This should not be called"
      end
    end

    maybe(1) do |n|
      assert_equal 1, n
    end

    just(1).maybe do |n|
      assert_equal 1, n
    end
  end

  def test_to_maybe_blocks
    1.to_maybe { |v| assert_equal 1, v }

    assert_nothing_raised do
      nil.to_maybe { raise Exception, "This should not run" }
    end
  end


  def test_maybe_block_return_value_and_type
    m = maybe(1).maybe { |n| n + 1 }
    assert_equal 2, m.value
    assert m.maybe?
    assert m.just?

    o = maybe(2).maybe { nil }
    assert_equal nil, o.value
    assert o.maybe?
    assert o.nothing?
  end

  def test_to_maybe
    assert_equal just(1), 1.to_maybe
    assert_equal just(1), just(1).to_maybe
    assert_equal nothing, nil.to_maybe
    assert_equal nothing, nothing.to_maybe
    #assert_equal 1.to_maybe, [1].to_maybe this shouldn't be the case, why's this here?
    assert_equal 0.to_maybe, (0..10).maybe_map { |n| n }.to_maybe
  end

  def test_then_and_and
    just(1).and do
      assert true
    end

    nothing.and do
      assert true
    end

    just(1).and{ assert true }.and{ assert true }
    maybe(1).then(->(){ assert true }).then(->(){ assert true })
  end

  def test_unwrap
    assert_equal maybe(1).unwrap(nil), maybe(nil).unwrap(1)
    assert_equal maybe(1).unwrap { 3 }, nothing.unwrap { 1 }
  end

  #
  # Monad laws
  #

  #
  # Right Unit:
  #   m >>= return = m
  #
  def test_right_unit
    m = just(1)
    assert_equal m, m.bind(->(x){ Monad::Maybe.return(x) })
  end

  #
  # Left Unit:
  #   return x >>= f = f x
  #
  def test_left_unit
    x = 2
    f = ->(x) { x + 1 }
    assert_equal Monad::Maybe.return(x).bind(f), f[x]
  end

  #
  # Associativity:
  #   (m >>= f) >>= g = m >>= (\x -> f x >>= g)
  #
  def test_associativity
    m = just(3.1459)
    f = ->(x) { x ** 2 }
    g = ->(x) { 2 *  x }
    assert_equal m.bind(f).bind(g), m.bind(->(x) { f[x] }).bind(g)
  end
end
