
class Room
  attr_accessor :name, :desc, :n, :e, :s, :w, :objects

  def initialize(name = 'The Void', desc = "There's nothing here!", n = -1, e = -1, s = -1, w = -1, objects = [])
    @name = name
    @desc = desc
    @n = n
    @e = e
    @s = s
    @w = w
    @objects = objects
  end


  # def scan_difficulty_table
  #   {
  #     0 => @name
  #     5 => @objects...
  #   }
  # end

  def to_s
    "#{name}:\n\n#{desc}"
  end

  # TODO: print exits add upon this 
end

