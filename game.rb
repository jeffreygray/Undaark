#!/usr/bin/env ruby

# TODO:
# Separate game into Client <> server

# initialize random number generator with seed
# Nightmare event randomly during game tic?
# Reconsider Input handling part of the player class instead of in game?

# room traps , doors getting shut, doors locked will have the -2 added
# quicksand, try to leave a few times before you  get out

require_relative 'room'
require_relative 'player'
require 'byebug'

# vars, etc
COMMANDS = { # constant-ish (frozen hash)
  north: 'n',
  east: 'e',
  south: 's',
  west: 'w',
  ree: 'ree',
  quit: 'quit',
  look: 'look',
  scan: 'scan',
  enter: 'enter',
  climbrope: 'climb rope',
  debug: 'debug' # remove me ree!
}.freeze

OPPOSITE = {
  north: :south,
  south: :north,
  east: :west,
  west: :east
}

def build_map                                                       #    N   E   S   W
  room0 = Room.new('Goblin\'s Lair', 'A dark den that smells of goblin', -1, 1, 2, -1, ['Goblin'])
  room1 = Room.new('Jungle', 'A tropical enclosure with whistling birds', -1, -1, -1, 0, ['Tree', 'Faerie'])
  room2 = Room.new('Cave', 'A spherical cave covered with ivy', 0, 3, -1, -1, ['Obelisk'])
  room3 = Room.new('Crypt', 'A gloomy crypt with diseased rats', -1, -1, -1, 2, ['Rat']*4)
  map = [room0, room1, room2, room3]
  map
end

def build_dungeon(difficulty, seed)
  start_index = @world_map.length

  entrance = Room.new('Dungeon Entrance', 'A rope descending down into a dungeon... or heading back out?', -1, -1, -1, -1, [])
  dungeon = [entrance]
  last_room = :entrance

  for b in 1..(1+2*difficulty) do
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
  @world_map += dungeon

  last_dir = nil
  next_dir = nil
  dirs = [:north, :south, :east, :west]
  dungeon.each_with_index do |room, di|
    if di > 0
      next_dir = dirs[Random.rand(dirs.length)]
      if last_dir
        while next_dir == OPPOSITE[last_dir]
          next_dir = dirs[Random.rand(dirs.length)]
        end
      end
      i = start_index + di
      connect_rooms(i - 1, i, next_dir)
      last_dir = next_dir
    end
  end

  start_index
end

def connect_rooms(room1_i, room2_i, dir)
  room1 = @world_map[room1_i]
  room2 = @world_map[room2_i]

  room1.send("#{COMMANDS[dir]}=", room2_i) if room1
  room2.send("#{COMMANDS[OPPOSITE[dir]]}=", room1_i) if room2
end

def move_player(dirshort, dirlong)
  unless @world_map[@player.location].send(dirshort) == -1
    @player.move_player(@world_map[@player.location].send(dirshort))
    puts("You moved #{dirlong}!")
    puts(@world_map[@player.location])
  else
    puts('You can\'t move that way!')
  end
end

def run_command(input)
  case input.downcase.strip
  when ""
    return
  when COMMANDS[:north]
    move_player(COMMANDS[:north], 'north')
  when COMMANDS[:east]
    move_player(COMMANDS[:east], 'east')
  when COMMANDS[:south]
    move_player(COMMANDS[:south], 'south')
  when COMMANDS[:west]
    move_player(COMMANDS[:west], 'west')
  when COMMANDS[:look]
    @player.look(@world_map[@player.location])
  when COMMANDS[:climbrope]
    if @world_map[@player.location].name == "Dungeon Vault" || @world_map[@player.location].name == "Dungeon Entrance"
      @player.leave_dungeon
    else
      puts("You're not in a dungeon entrance or exit.")
    end
  when COMMANDS[:enter]
    @player.enter_dungeon(build_dungeon(5, 0))
    puts("You entered a new dungeon!")
  when COMMANDS[:debug]
    puts("Entering debug mode, use 'pw' to print the world")
    byebug
  when COMMANDS[:scan]
    @player.scan(@world_map)
  when COMMANDS[:quit]
    puts('Quitting the game...')
    exit
  else
    puts("#{input} unrecognized... please try another command.")
  end
end

# Game Loop
def start_game
  input = ''
  output = ''
  s = "Welcome, #{@player.name}. What would you like to do? You're in #{@world_map[@player.location]}"
  puts(s)
  loop do
    print("> ")
    input = gets
    # TODO: make this do shit
    output = run_command(input)
    puts(output)
  end
end

def pw
  @world_map.each_with_index do |room, inx|
    puts "room:#{inx} n: #{room.n}, e: #{room.e}, s: #{room.s}, w: #{room.w} name: #{room.name}"
  end
end


@player = Player.new('Adventurer', 0, 15, 15, 15)
@goblin = Player.new('Goblin', 1, 15, 15, 15)
@world_map = build_map
start_game
