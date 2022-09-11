require 'byebug'

class Player
  attr_accessor :name, :location

  def initialize(name = nil, location = 0, str = 15, dex = 15, int = 15)
    @name = name
    @location = location
    @str = str
    @dex = dex
    @int = int
  end


  def move_player(newroom)
    @location = newroom
  end

  def look(map)
    s = ''
    map[location].objects.each do |object| # Note: iterating 
      s += "#{object}\n"
    end
    "#{s}\n"
  end

  def scan(map)
    s = ''
    #byebug
    # roll dice related to some future perception check, you see a "room.name"
    s += "North of you, you see: #{map[map[location].n].name}\n" if map[location].n != -1
    s += "To the east, you see: #{map[map[location].e].name}\n" if map[location].e != -1
    s += "Towards the south, you see: #{map[map[location].s].name}\n" if map[location].s != -1
    s += "As you look westward, you see: #{map[map[location].w].name}\n" if map[location].w != -1
    "#{s}\n"
  end

end