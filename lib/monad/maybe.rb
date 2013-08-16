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
    j = Monad::Maybe::Just.new(self)
    blk ? j.maybe(&blk) : j
  end
  
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

class NilClass
  def to_maybe(&blk)
    Monad::Maybe::Nothing.instance
  end
end

module Monad
  module Maybe
    def self.return(obj)
      obj.to_maybe
    end
  end
end

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
