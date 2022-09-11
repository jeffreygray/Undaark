#!/usr/bin/env ruby

# 1. unrecognized
# 2. Walk around
# 3. Add room method from within the game (assume Immortal)
# kanye structure?
# look before you leap 

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
  debug: 'debug' # remove me ree!
}.freeze

def build_map                                                       #    N   E   S   W
  room0 = Room.new('Goblin\'s Lair', 'A dark den that smells of goblin', -1, 1, 2, -1)
  room1 = Room.new('Jungle', 'A tropical enclosure with whistling birds', -1, -1, -1, 0)
  room2 = Room.new('Cave', 'A spherical cave covered with ivy', 0, 3, -1, -1)
  room3 = Room.new('Crypt', 'A gloomy crypt with diseased rats', -1, -1, -1, 2)
  map = [room0, room1, room2, room3]
  map
end

def move_player(dirshort, dirlong)
  unless @world_map[@jingle.location].send(dirshort) == -1 
    @jingle.move_player(@world_map[@jingle.location].send(dirshort))
    puts("You moved #{dirlong}!")
    puts(@world_map[@jingle.location])
  else
    puts('You can\'t move that way!')
  end
end

def run_command(input)
  case input.downcase.strip
  when COMMANDS[:north]
    move_player(COMMANDS[:north], 'north')
  when COMMANDS[:east]
    move_player(COMMANDS[:east], 'east')
  when COMMANDS[:south]
    move_player(COMMANDS[:south], 'south')
  when COMMANDS[:west]
    move_player(COMMANDS[:west], 'west')
  when COMMANDS[:debug]
    byebug
  when COMMANDS[:quit]
    puts('Quitting the game...')
    exit
  else
    puts("#{input} unrecognized... please try another command!")
  end
end

# Game Loop 
def start_game
  input = ''
  output = ''
  s = "Welcome, #{@jingle.name}. What would you like to do? You're in #{@world_map[@jingle.location]}"
  puts(s)
  loop do
    print("> ")
    input = gets
    # TODO: make this do shit
    output = run_command(input)
    puts(output)
  end
end

@jingle = Player.new('Jingle', 0)
@world_map = build_map
start_game