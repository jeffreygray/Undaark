#!/usr/bin/env ruby

require_relative 'game'
require 'byebug'

# vars, etc
NORTH = 'north';
EAST = 'east';
SOUTH =  'south';
WEST = 'west';
QUIT = 'quit';
LOOK = 'look';
SCAN = 'scan';
ENTER = 'enter';
CLIMB_ROPE = 'climb-rope';
DEBUG = 'debug';

COMMANDS = { # constant-ish (frozen hash)
  north: NORTH,
  n: NORTH,
  east: EAST,
  e: EAST,
  south: SOUTH,
  s: SOUTH,
  west: WEST,
  w: WEST,
  quit: QUIT,
  look: LOOK,
  "look around": LOOK,
  scan: SCAN,
  enter: ENTER,
  "climb rope": CLIMB_ROPE,
  debug: DEBUG # remove me ree!
}.freeze


def move_player(dirshort)
  result = @game.move_player(dirshort)
  if result[0]
    puts("You moved #{dirshort}!")
    puts(@game.get_player_room())
  else
    puts(result[1])
  end
end

def run_command(input)
  if not input
    input = QUIT
  end
  case COMMANDS[input.downcase.strip.to_sym]
  when ""
    return
  when NORTH
    move_player(NORTH)
  when EAST
    move_player(EAST)
  when SOUTH
    move_player(SOUTH)
  when WEST
    move_player(WEST)
  when LOOK
    @game.player_look()
  when CLIMB_ROPE
    if @game.climb_rope()
      puts("You climb the rope back up to #{@game.get_player_room()}")
    else
      puts("There's no rope here to climb")
    end
  when ENTER
    if @game.enter_dungeon()
      puts("You entered a new dungeon!")
      puts(@game.get_player_room())
    else
      puts("You can't enter a dungeon here")
    end
  when DEBUG
    puts("Entering debug mode, use 'pw' to print the world")
    byebug
  when SCAN
    scan()
  when QUIT
    puts('Quitting the game...')
    exit
  else
    puts("#{input} unrecognized... please try another command.")
  end
end

def scan
  adj = @game.player_adjacent_rooms
  #byebug
  s=""
  # roll dice related to some future perception check, you see a "room.name"
  s += "North of you, you see: #{adj[:north].name}\n" if adj[:north]
  s += "To the east, you see: #{adj[:east].name}\n" if adj[:east]
  s += "Towards the south, you see: #{adj[:south].name}\n" if adj[:south]
  s += "As you look westward, you see: #{adj[:west].name}\n" if adj[:west]
  "#{s}\n"
end

# Game Loop
def start_game
  name = 'Adventurer'
  input = ''
  output = ''
  s = "Welcome, #{name}. What would you like to do? You're in a #{@game.get_player_room}" #Sara says we should look at how we handle the grammar of this one. Should (a) be in the room generator?
  puts(s)
  loop do
    print("> ")
    input = gets
    # TODO: make this do shit
    output = run_command(input)
    puts(output)
  end
end


@game = Game.new
start_game
