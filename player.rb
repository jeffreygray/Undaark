class Player
  attr_accessor :name, :location

  def initialize(name = nil, location = 0)
    @name = name
    @location = location
  end

  def move_player(newroom)
    @location = newroom
  end
end