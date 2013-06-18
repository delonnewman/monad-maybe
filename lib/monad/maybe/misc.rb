#
# Some monkey patching and constructor methods.
#
module Enumerable
  def to_maybe
    first.maybe
  end
  
  def maybe_map
    Monad::Maybe::List.new(map{ |x| yield(x) })
  end
end
  
class Object
  def maybe(obj=self, &blk)
    if obj && blk
      blk.call(obj).to_maybe
    else
      obj.to_maybe
    end
  end

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
    Monad::Maybe::Nothing.instance.freeze
  end

  def maybe(&blk)
    to_maybe
  end
end

def just(o)
  Monad::Maybe::Just.new(o)
end

def nothing
  Monad::Maybe::Nothing.instance
end
