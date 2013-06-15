require 'singleton'

module MaybeMonad
  class MaybeList
    include Enumerable

    def initialize(enum)
      @enum = enum.map { |v| v = v.maybe unless v.maybe?; v }
    end

    def inspect
      "#{to_a}"
    end

    def maybe?
      true
    end

    def <<(obj)
      @enum << obj if obj.is_a?(Just)
      self
    end

    def to_a
      @enum.to_a
    end

    def to_maybe
      Maybe.create(first)
    end
    alias maybe to_maybe

    def each
      @enum.each do |x|
        yield(x)
      end
    end

    def map
      e = []
      each do |x|
        e << yield(x)
      end
      MaybeList.new(e)
    end
    alias maybe_map map

    def select
      e = []
      each do |x|
        is_true = yield(x)
        e << x if is_true  
      end
      MaybeList.new(e)
    end

    def reject
      select { |x| !yield(x) }
    end

    def select_just
      select { |x| x.just? }
    end

    def unwrap_map(default)
      to_a.map { |x| x.unwrap(default) }
    end

    def select_just_map_value
      select_just.value_map
    end

    def value_map
      to_a.map { |x| x.value }
    end
  end

  class Maybe
    def self.create(val)
      (val.nil? && Nothing.instance.freeze) || Just.new(val)
    end

    def <<(obj)
      to_list << obj
    end

    def maybe?
      true
    end

    def to_maybe
      self
    end
    alias maybe to_maybe

    def to_list
      MaybeList.new(to_a)
    end

    private
    def initialize; end
  end

  #
  # Wraps a non-nil object allows us to treat these
  # objects as a Maybe while distinguishing them from
  # a Nothing
  #
  class Just < Maybe
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def method_missing(method, *args)
      Just.new(value.send(method, *args))
    end

    def unwrap(val)
      value
    end

    def nothing?
      false
    end

    def just?
      true
    end

    def nil?
      false
    end

    def ==(other)
      self === other || self.value == other
    end

    def ===(other)
      other.just? && self.value == other.value
    end

    def equal?(other)
      other.__id__ == self.__id__
    end

    def inspect
      "just(#{value.inspect})"
    end

    def to_s
      inspect
    end

    def to_a
      [self]
    end
  end

  #
  # A better nil
  #
  class Nothing < Maybe
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

  module MaybeEnumerable
    def to_maybe
      Maybe.create(first)
    end

    def maybe_map
      MaybeList.new(map{ |x| yield(x) })
    end
  end

  class ::Array; include MaybeEnumerable end
  class ::Range; include MaybeEnumerable end
  class ::Enumerator::Lazy; include MaybeEnumerable end
  class MaybeList; include MaybeEnumerable end

  class ::Object
    def to_maybe
      Maybe.create(self)
    end
    alias maybe to_maybe

    def maybe?
      false
    end

    def just?
      false
    end

    def nothing?
      false
    end
  end
end

include MaybeMonad
