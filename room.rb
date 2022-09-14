
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
    @exits = get_current_room_exits # TODO: make sure this works
  end

  # making this method instead of having [exits] in initializer since we build exits in world_map
  # TODO: Uncomment this or delete 
    # We might keep this or just use adjacent rooms
  def get_current_room_exits
    exits = []
    exits.append("North") if @n != -1
    exits.append("East") if @e != -1
    exits.append("South") if @s != -1
    exits.append("West") if @w != -1
    exits 
  end

  # def scan_difficulty_table
  #   {
  #     0 => @name
  #     5 => @objects...
  #   }
  # end

  def to_s
    "#{name}:\n\n#{desc}\n\nExits: #{get_current_room_exits.to_s.delete("\"[]")}"
  end

  # TODO: print exits add upon this
end

