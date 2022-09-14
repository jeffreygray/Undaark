#!/usr/bin/env ruby

require_relative 'game'
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


def move_player(dirshort, dirlong)
  if @game.move_player(dirshort)
    puts("You moved #{dirlong}!")
    puts(@game.get_player_room())
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
    @game.player_look()
  when COMMANDS[:climbrope]
    if @game.climb_rope()
      puts("You climb the rope back up to #{@game.get_player_room()}")
    else
      puts("There's no rope here to climb")
    end
  when COMMANDS[:enter]
    if @game.enter_dungeon()
      puts("You entered a new dungeon!")
      puts(@game.get_player_room())
    else
      puts("You can't enter a dungeon here")
    end
  when COMMANDS[:debug]
    puts("Entering debug mode, use 'pw' to print the world")
    byebug
  when COMMANDS[:scan]
    scan()
  when COMMANDS[:quit]
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
  s = "Welcome, #{name}. What would you like to do? You're in #{@game.get_player_room}"
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
