require 'test/unit'
require_relative '../lib/monad/maybe'

class MaybeTest < Test::Unit::TestCase
  def test_nothing
    assert nil.maybe.nothing?
    assert nil.maybe.value.nil?
    assert_equal 'test', nil.maybe.unwrap('test')
  end

  def test_just
    assert 1.maybe.just?
    assert_equal 1, 1.maybe.value
    assert_equal 1, 1.maybe.unwrap('test')
  end

  def test_to_a
    assert_equal [1.maybe], 1.maybe.to_a
    assert_equal [], nil.maybe.to_a
  end

  def test_false
    assert_equal false, false.maybe.value
  end

  def test_nil_conversions
    assert_equal nil.nil?, nil.maybe.nil?
  end

  def test_class
    assert_equal Nothing, nil.maybe.class
    assert_equal Just, 1.maybe.class
  end

  def test_list
    xs = true.maybe << nil.maybe << 1.maybe << 3.maybe
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
end
