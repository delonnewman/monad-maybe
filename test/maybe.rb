require 'test/unit'
require_relative '../lib/dragnet/utils/maybe'

class MaybeTest < Test::Unit::TestCase
  include Dragnet::Utils
  
  def test_nothing
    assert_equal maybe{ nil }, maybe{ nil }
  end

  def test_just
    assert maybe{ 1 }.just?
  end

  def test_to_a
    assert_equal [maybe{1}], maybe{1}.to_a
    assert_equal [],  maybe{nil}.to_a
  end

  def test_false
    assert_false maybe{ false }.from_just
  end

  def test_conditionals
  end

  def test_nil_conversions
    methods = [ :nil?, :to_a, :to_c, :to_f, :to_h, :to_i, :to_r, :to_s ]
    methods.each do |m|
      assert_equal nil.send(m), maybe{ nil }.send(m)
    end
  end

  def test_plus_op
    assert_equal "hey there", maybe{ nil } + "hey there"
    assert_equal 1, maybe{ nil } + 1
  end

  def test_minus_op
    assert_equal -1, maybe{ nil } - 1
    assert_equal maybe{ nil }, -maybe{ nil }
  end

  def test_mult_op
    assert_equal "", maybe{ nil } * "Something" 
    assert_equal 0, maybe{ nil } * 9
  end

  def test_comparison_ops
    assert maybe{ nil } < 1
    assert maybe{ nil } > -1
    assert maybe{ nil } <= maybe{ nil }
    assert maybe{ nil } <= 0
    assert maybe{ nil } <= nil
    assert maybe{ nil } >= -4
  end

  def test_class
    assert_equal Nothing, maybe{ nil }.class
  end

  def test_list
    xs = maybe{ true } << maybe{ nil } << maybe{ 1 } << maybe{ 3 }
    assert_equal 3, list.count
    xs.map { |x| assert x.just? }
  end
end
