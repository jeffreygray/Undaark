#!/usr/bin/env ruby

# 1. unrecognized
# 2. Walk around
# 3. scan function: Can the player investigate the world?
# 4. How could states change? Can I have some form of advancing?
# 5. More rats? 
# 6. Nightmare event randomly during game tic?

# TODO: Reconsider Input handling part of the player class instead of in game?

# room traps , doors getting shut
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
  entrance = Room.new('Dungeon Entrance', 'Stairs leading down into a dungeon... or heading back out?', -1, -1, -1, -1, [])
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
        dungeon.append(Room.new('Combat Room', "A single #{enemy} stands in the room"))
      end
      last_room = next_room
    end
  end
  vault = Room.new('Dungeon Vault')
  dungeon.append(vault)
  @world_map += dungeon
  dungeon.each_with_index do |room, di|
    if di > 0
      i = start_index + di
      # connect_rooms(start_index + i - 1, start_index + i, :south)
      # entrance.s = start_index + dungeon.length
      dungeon[di - 1].s = i
      room.n = i - 1
    end
  end
  start_index
end

def connect_rooms(room1_i, room2_i, dir)
  # byebug 
  # @world_map[room1_i].send(COMMANDS[dir]) = room2_i
  # @world_map[room1_i].send(COMMANDS[OPPOSITE[dir]]) = room2_i
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
  when COMMANDS[:enter]
    @player.move_player(build_dungeon(5, 0))
    puts("You entered a new dungeon!")
  when COMMANDS[:debug]
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


@player = Player.new('Adventurer', 0, 15, 15, 15)
@goblin = Player.new('Goblin', 1, 15, 15, 15)
@world_map = build_map
start_game
