require 'singleton'

module Monad
  private

  module Maybe
    def <<(obj)
      to_list << obj
    end

    def maybe?
      true
    end
  end

  class MaybeList
    include Enumerable

    def self.create(obj=nil)
      if obj.is_a?(Just)
        MaybeList.new(obj)
      else
        MaybeList.new
      end
    end

    def initialize(obj)
      @list = []
      self << obj
    end

    def inspect
      "[#{@list.to_a.join(', ')}]"
    end

    def <<(obj)
      @list << obj if obj.is_a?(Just)
      self
    end

    def each
      @list.each do |x|
        yield x
      end
    end
  end

  #
  # Wraps a non-nil object allows us to treat these
  # objects as a Maybe while distinguishing them from
  # a Nothing
  #
  class Just
    include Maybe

    def initialize(&blk)
      @blk = blk
    end

    def call
      @value ||= @blk.call
    end
    alias from_just call
    alias value call

    def from_maybe(val)
      from_just
    end
    alias unwrap from_maybe

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
      other.is_a?(Just) ? call == other.call : false 
    end

    def equal?(other)
      other.__id__ == self.__id__
    end
    alias === equal?

    def is_a?(klass)
      klass == Maybe or klass == Just or klass == BasicObject
    end
    alias kind_of? is_a?

    def inspect
      "just(#{call.inspect})"
    end

    def to_s
      inspect
    end

    def to_a
      [self]
    end

    def to_list
      MaybeList.new(self)
    end

    def to_json(*args)
      call.to_json
    end

    def class
      Just
    end
  end

  #
  # A better nil
  #
  class Nothing
    include Maybe
    include ::Singleton

    def method_missing(method, *args)
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

    def from_maybe(val)
      val
    end
    alias unwrap from_maybe

    def value
      nil
    end

    def to_json(*args)
      'null'
    end

    # collection methods

    def to_list
      MaybeList.new
    end

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

    # type introspection methods

    def class
      Nothing
    end

    def instance_of?(klass)
      klass == Nothing
    end

    def is_a?(klass)
      klass == Maybe or klass == Nothing or klass == Object
    end
    alias kind_of? is_a?

    def clone
      self
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

  public

  def maybe(default=nil, &blk)
    m = ((val = blk.call).nil? && Nothing.instance.freeze) || Just.new{ val }
    default ? m.from_maybe(default) : m
  end

  def nothing
    Nothing.instance.freeze
  end

  def just(&blk)
    Just.new(&blk)
  end

  module MaybeEnumerable
    def to_maybe
      maybe{ first }
    end

    def cat_maybes
      select { |x| x.is_a?(Maybe) && x.just? }
    end
    alias select_just cat_maybes
    alias filter_just cat_maybes

    def map_maybe
      map do |x|
        maybe{ yield x }
      end
    end

    def map_from_maybe(default)
      map do |x|
        x.is_a?(Maybe) && x.from_maybe(default)
      end
    end
    alias map_unwrap map_from_maybe

    def map_from_just
      map do |x|
        raise Exception, "#{x} is not a Just instance" unless x.is_a?(Just)
        x.from_just
      end
    end

    def filter_map_just
      filter_just.map_from_just
    end
    alias select_map_just filter_map_just
  end

  class ::Array; include MaybeEnumerable end
  class ::Range; include MaybeEnumerable end
  class ::Enumerator::Lazy; include MaybeEnumerable end
  class MaybeList; include MaybeEnumerable end
end

include Monad
