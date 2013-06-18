require 'test/unit'
require_relative '../lib/monad/maybe'
require_relative '../lib/monad/maybe/json'

class MaybeTest < Test::Unit::TestCase
  def test_nothing
    assert nil.maybe.nothing?
    assert nil.maybe.value.nil?
    assert_equal 'test', nil.maybe.unwrap('test')
    assert_equal '', nothing.to_s
  end

  def test_just
    assert 1.maybe.just?
    assert_equal 1, 1.maybe.value
    assert_equal 1, 1.maybe.unwrap('test')
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
    assert_equal Monad::Maybe::Nothing, nil.maybe.class
    assert_equal Monad::Maybe::Just, 1.maybe.class
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

  def test_maybe_block
    assert_nothing_raised do
      nil.maybe do
        raise Exception, "This should not be called"
      end
    end
  
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

    1.maybe do |n|
      assert_equal 1, n
    end

    maybe(1) do |n|
      assert_equal 1, n
    end

    just(1).maybe do |n|
      assert_equal 1, n
    end
  end

  def test_maybe_block_return_value_and_type
    m = 1.maybe { |n| n + 1 }
    assert_equal 2, m.value
    assert m.maybe?
    assert m.just?

    o = 2.maybe { nil }
    assert_equal nil, o.value
    assert o.maybe?
    assert o.nothing?
  end

  def test_something?
    assert_equal false, nil.something?
    assert_equal false, nothing.something?
    assert 1.something?
    assert 1.maybe.something?
    assert (0..10).maybe_map { |n| n }.something?
  end

  def test_to_maybe
    assert_equal just(1), 1.to_maybe
    assert_equal just(1), just(1).to_maybe
    assert_equal nothing, nil.to_maybe
    assert_equal nothing, nothing.to_maybe
    assert_equal 1.to_maybe, [1].to_maybe
    assert_equal 0.to_maybe, (0..10).maybe_map { |n| n }.to_maybe
  end
end
