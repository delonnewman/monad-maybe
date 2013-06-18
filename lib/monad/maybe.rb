require_relative '../monad'
require_relative 'maybe/just'
require_relative 'maybe/nothing'
require_relative 'maybe/list'
require_relative 'maybe/misc'

class Maybe
  include Monad

  def self.return(value)
    super(Just.new(value))
  end

  def bind(fn)
    @value.bind(fn)
  end
end
