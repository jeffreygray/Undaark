
class Room
  attr_accessor :name, :desc, :n, :e, :s, :w

  def initialize(name = 'The Void', desc = "There's nothing here!", n = -1, e = -1, s = -1, w = -1)
    @name = name
    @desc = desc
    @n = n
    @e = e
    @s = s
    @w = w
  end
end

