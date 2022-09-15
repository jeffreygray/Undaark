
class Room
  attr_accessor :name, :desc, :north, :east, :south, :west, :objects, :enemies

  def initialize(name = 'The Void', desc = "There's nothing here!", north = -1, east = -1, south = -1, west = -1, objects = [], enemies = [])
    @name = name
    @desc = desc
    @north = north
    @east = east
    @south = south
    @west = west
    @objects = objects
  end

  def is_locked
    false
  end

  def has_combat
    objects.any? { |o| o.fights? }
  end
  
  def has_enemy(enemy_name)
    objects.any? { |o| o.fights? and o.name.downcase == enemy_name.downcase }
  end

  def get_enemy(enemy_name)
      objects.each do |object|
          if object.fights? and object.name.downcase == enemy_name.downcase
              return object
          end
      end
      return nil
  end

  # making this method instead of having [exits] in initializer since we build exits in world_map
  # TODO: Uncomment this or delete 
    # We might keep this or just use adjacent rooms
  def get_current_room_exits
    exits = []
    exits.append(NORTH) if @north != -1
    exits.append(EAST) if @east != -1
    exits.append(SOUTH) if @south != -1
    exits.append(WEST) if @west != -1
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

