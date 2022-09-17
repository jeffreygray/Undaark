class WorldMap

  attr_accessor :instances

  def initialize
    room0 = Room.new('Goblin\'s Lair', 'A dark den that smells of goblin', -1, 1, 2, -1, ['Goblin'])
    room1 = Room.new('Jungle', 'A tropical enclosure with whistling birds', -1, -1, -1, 0, %w[Tree Faerie])
    room2 = Room.new('Cave', 'A spherical cave covered with ivy', 0, 3, -1, -1, ['Obelisk'])
    room3 = Room.new('Crypt', 'A gloomy crypt with diseased rats', -1, -1, -1, 2, ['Rat'] * 4)

    # TODO: should move out of initialize method
    # overworld = [room0, room1, room2, room3]
    overworld = create_path(Generators::Room.build(5))
    @instances = [overworld]
  end

  def get_room(instance, location)
    if instance.nil?
      instance = 0
    end
    if location == -1
      nil
    else
      @instances[instance][location]
    end
  end

  def move_from_to(instance, location, dir)
    get_room(instance, location).send(dir)
  end

  def can_move_from_to(instance, location, dir)
    move_from_to(instance, location,
                 dir
    ) != -1 and !get_room(instance, location).is_locked and !get_room(instance, location).has_combat
  end

  def adjacent_rooms(instance, location)
    room = get_room(instance, location)
    {
      north: get_room(instance, room.north),
      east:  get_room(instance, room.east),
      south: get_room(instance, room.south),
      west:  get_room(instance, room.west)
    }
  end

  def build_dungeon(difficulty, seed = nil)
    random = if seed.nil?
      Random.new
    else
      Random.new seed
    end

    entrance = Room.new('Dungeon Entrance', 'A rope descending down into a dungeon... or heading back out?', -1, -1,
                        -1, -1, []
    )
    dungeon = [entrance]
    last_room = :entrance

    (1 + 2 * difficulty).times do
      next unless random.rand < 0.5

      # new room Markov chain
      case last_room
        when :entrance
          next_room = :corridor
        when :corridor
          next_room = if random.rand < 0.1 # Original .4
            :corridor
          elsif random.rand < 0.8 # Original .5
            :mob
          else
            :trap
          end
        when :mob
          next_room = if random.rand < 0.3
            :mob
          else
            :corridor
          end
        when :trap
          next_room = :mob
      end

      case next_room
        when :corridor
          if random.rand < 0.5
            dungeon.append(Room.new('Dungeon Corridor', 'An eerie corridor lined with torches and cobwebs'))
          else
            dungeon.append(Room.new('Dungeon Corridor', 'A dusty path'))
          end
        when :trap
          if random.rand(3) < 1
            dungeon.append(QuicksandRoom.new('Quicksand', 'AAAAAAAAAAAAAAAAAAAAA'))
          elsif random.rand < 0.5
            dungeon.append(Room.new('Innocent-Looking Room', 'It\'s just a room'))
          else
            dungeon.append(Room.new('Puzzle Room', 'idk figure it out'))
          end
        when :mob
          enemies = %w[Goblin Kobold Ghast Skeleton Newt Giant-Rat]
          enemy = enemies[random.rand(enemies.length)]
          params = {
            name:              enemy,
            combat_preference: %w[rock paper scissors][rand(0..2)],
            undead:            %w[Ghast Skeleton].include?(enemy)
          }
          dungeon.append(Room.new('Combat Room', "A single #{enemy} stands in the room", -1, -1, -1, -1,
                                  [Things::Enemy.new(params)]
          )
                        )
      end
      last_room = next_room
    end

    chest_min = difficulty / 2
    chest_max = difficulty * 3 / 2
    if chest_min + chest_max + 1 == 2 * difficulty # if difficulty is odd
      chest_max += 1
    end
    chest = Things::Chest.new({ loot: random.rand(chest_min..chest_max) })
    vault = Room.new('Dungeon Vault',
                     'You reach a dead end in the dungeon, with a chest by the wall and a rope leading back up to the surface', -1, -1, -1, -1, [Things::Rope.new({}), chest]
    )
    dungeon.append(vault)

    instance = add_instance(create_path(dungeon, random))
  end

  def create_path(rooms, random = nil)
    if random.nil?
      random = Random.new
    end
    last_dir = nil
    (rooms.count - 1).times do |i|
      # next_dir = DIRS.sample  # how to sample using random?
      next_dir = DIRS[random.rand(DIRS.length)]
      if last_dir
        while next_dir == OPPOSITE[last_dir]
          # next_dir = DIRS.sample
          next_dir = DIRS[random.rand(DIRS.length)]
        end
      end
      rooms[i].send("#{COMMANDS[next_dir]}=", i + 1)
      rooms[i + 1].send("#{COMMANDS[OPPOSITE[next_dir]]}=", i)
      last_dir = next_dir
    end
    rooms
  end

  def add_instance(rooms)
    @instances.append(rooms)
    @instances.length - 1
  end

  def pw
    @instances.each_with_index do |map, _instance|
      map.each_with_index do |room, inx|
        puts "room:#{inx} n: #{room.north}, e: #{room.east}, s: #{room.south}, w: #{room.west}, name: #{room.name}, description: #{room.desc}"
      end
    end
  end

end
