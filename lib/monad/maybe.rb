require_relative 'maybe/base'
require_relative 'maybe/just'
require_relative 'maybe/nothing'
require_relative 'maybe/list'

#
# Some monkey patching and constructor methods.
#
module Enumerable
  def maybe_map
    Monad::Maybe::List.new(map{ |x| yield(x) })
  end
end
  
class Object
  def to_maybe(&blk)
    j = Monad::Maybe.return(self)
    blk ? j.maybe(&blk) : j
  end
end

class NilClass
  def to_maybe(&blk)
    Monad::Maybe::Nothing.instance
  end
end

module Monad
  module Maybe
    def self.return(obj)
      if obj.nil? or nothing? obj
        Monad::Maybe::Nothing.instance
      else
        Monad::Maybe::Just.new(obj)
      end
    end
  end
end

# some toplevel methods

def maybe(obj, &blk)
  m = Monad::Maybe.return(obj)
  blk ? m.maybe(&blk) : m
end

def just(o)
  Monad::Maybe::Just.new(o)
end

def nothing
  Monad::Maybe::Nothing.instance
end

module Kernel
  def maybe?(x=nil)
    return false if x.nil? # we assume it's being called as a method on an object like 0.maybe?
    if not x.is_a? Monad::Maybe::Base
      false
    else
      true
    end
  end
  
  def just?(x=nil)
    return false if x.nil? # we assume it's being called as a method on an object like 0.maybe?
    if not x.is_a? Monad::Maybe::Just
      false
    else
      true
    end
  end
  
  def nothing?(x)
    return false if x.nil? # we assume it's being called as a method on an object like 0.maybe?
    if x == Monad::Maybe::Nothing.instance
      true
    else
      false
    end
  end
end
