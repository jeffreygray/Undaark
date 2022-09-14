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
require_relative 'world_map'
require_relative 'generators/room'
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

DIRS = %i[
  north
  south
  east
  west
].freeze

def move_player(dirshort, dirlong)
  if @world_map.can_move_from_to(@player.instance, @player.location, dirshort)
    @player.move_player(@world_map.move_from_to(@player.instance, @player.location, dirshort))
    puts("You moved #{dirlong}!")
    puts(@world_map.get_room(@player.instance, @player.location))
  else
    puts('You can\'t move that way!')
  end
end

def run_command(input)
  if not input
    input = COMMANDS[:quit]
  end
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
    @player.look(@world_map.get_room(@player.instance, @player.location))
  when COMMANDS[:climbrope]
    if ["Dungeon Entrance", "Dungeon Vault"].include? @world_map.get_room(@player.instance, @player.location).name
      @player.leave_instance
      puts("You climb the rope back up to #{@world_map.get_room(@player.instance, @player.location).name}")
    else
      puts("You're not in a dungeon entrance or exit.")
    end
  when COMMANDS[:enter]
    if @player.is_in_instance
      puts("You're already in a dungeon!")
    else
      @player.enter_instance(@world_map.build_dungeon(5, 0))
      puts("You entered a new dungeon!")
      puts(@world_map.get_room(@player.instance, @player.location))
    end
  when COMMANDS[:debug]
    puts("Entering debug mode, use 'pw' to print the world")
    byebug
  when COMMANDS[:scan]
    @player.scan(@world_map.adjacent_rooms(@player.instance, @player.location))
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
  s = "Welcome, #{@player.name}. What would you like to do? You're in #{@world_map.get_room(@player.instance, @player.location)}"
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
@world_map = WorldMap.new
start_game
