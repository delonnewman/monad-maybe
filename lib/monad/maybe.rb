require_relative 'maybe/base'
require_relative 'maybe/just'
require_relative 'maybe/nothing'
require_relative 'maybe/list'

#
# Some monkey patching and constructor methods.
#
module Enumerable
  def to_maybe
    first.to_maybe
  end
  
  def maybe_map
    Monad::Maybe::List.new(map{ |x| yield(x) })
  end
end
  
class Object
  def to_maybe
    Monad::Maybe::Just.new(self)
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
  def to_maybe
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

def maybe(obj)
  Monad::Maybe.return(obj)
end

def just(o)
  Monad::Maybe::Just.new(o)
end

def nothing
  Monad::Maybe::Nothing.instance
end
