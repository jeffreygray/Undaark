class WorldMap

  attr_accessor :map

  def initialize()
    room0 = Room.new('Goblin\'s Lair', 'A dark den that smells of goblin', -1, 1, 2, -1, ['Goblin'])
    room1 = Room.new('Jungle', 'A tropical enclosure with whistling birds', -1, -1, -1, 0, ['Tree', 'Faerie'])
    room2 = Room.new('Cave', 'A spherical cave covered with ivy', 0, 3, -1, -1, ['Obelisk'])
    room3 = Room.new('Crypt', 'A gloomy crypt with diseased rats', -1, -1, -1, 2, ['Rat']*4)

    # TODO: should move out of initialize method
    @map = [room0, room1, room2, room3]
    add_rooms(Generators::Room.build(5), @map.length - 1)
  end

  def get_room(location)
    if location == -1
      nil
    else
      @map[location]
    end
  end

  def move_from_to(location, dir)
    get_room(location).send(dir)
  end

  def can_move_from_to(location, dir)
    move_from_to(location, dir) != -1
  end

  def adjacent_rooms(location)
    room = get_room(location)
    {
      north: get_room(room.n),
      east: get_room(room.e),
      south: get_room(room.s),
      west: get_room(room.w)
    }
  end

  def connect_rooms(room1_i, room2_i, dir)
    room1 = @map[room1_i]
    room2 = @map[room2_i]

    room1.send("#{COMMANDS[dir]}=", room2_i) if room1
    room2.send("#{COMMANDS[OPPOSITE[dir]]}=", room1_i) if room2
  end

  def build_dungeon(difficulty, seed)
    start_index = @map.length

    entrance = Room.new('Dungeon Entrance', 'A rope descending down into a dungeon... or heading back out?', -1, -1, -1, -1, [])
    dungeon = [entrance]
    last_room = :entrance

    (1+2*difficulty).times do
      if Random.rand < 0.5
        # new room Markov chain
        case last_room
        when :entrance
          next_room = :corridor
        when :corridor
          if Random.rand < 0.4
            next_room = :corridor
          elsif Random.rand < 0.5
            next_room = :mob
          else
            next_room = :trap
          end
        when :mob
          if Random.rand < 0.3
            next_room = :mob
          else
            next_room = :corridor
          end
        when :trap
          next_room = :mob
        end

        case next_room
        when :corridor
          if Random.rand < 0.5
            dungeon.append(Room.new('Dungeon Corridor', 'An eerie corridor lined with torches and cobwebs'))
          else
            dungeon.append(Room.new('Dungeon Corridor', 'A dusty path'))
          end
        when :trap
          if Random.rand(3) < 1
            dungeon.append(Room.new('Quicksand', 'AAAAAAAAAAAAAAAAAAAAA'))
          elsif Random.rand < 0.5
            dungeon.append(Room.new('Innocent-Looking Room', 'It\'s just a room'))
          else
            dungeon.append(Room.new('Puzzle Room', 'idk figure it out'))
          end
        when :mob
          enemies = ['Goblin', 'Kobold', 'Ghast', 'Skeleton', 'Newt', 'Giant Rat']
          enemy = enemies[Random.rand(enemies.length)]
          dungeon.append(Room.new('Combat Room', "A single #{enemy} stands in the room", -1, -1, -1, -1, [enemy]))
        end
        last_room = next_room
      end
    end

    vault = Room.new('Dungeon Vault', 'There\'s nothing here', -1, -1, -1, -1, ['Rope'])
    dungeon.append(vault)

    add_rooms(dungeon, start_index + 1)

    start_index
  end

  def add_rooms(rooms, start_index)
    @map += rooms

    last_dir = nil

    (rooms.count + 1).times do |ri|
      next_dir = DIRS.sample
      if last_dir
        while next_dir == OPPOSITE[last_dir]
          next_dir = DIRS.sample
        end
      end
      i = start_index + ri
      connect_rooms(i - 1, i, next_dir)
      last_dir = next_dir
    end
  end

  def pw
    @map.each_with_index do |room, inx|
      puts "room:#{inx} n: #{room.n}, e: #{room.e}, s: #{room.s}, w: #{room.w} name: #{room.name}"
    end
  end

end
