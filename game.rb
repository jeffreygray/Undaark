#!/usr/bin/env ruby

# 1. unrecognized
# 2. Walk around
# 3. scan function: Can the user investigate the world?
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
  debug: 'debug' # remove me ree!
}.freeze

def build_map                                                       #    N   E   S   W
  room0 = Room.new('Goblin\'s Lair', 'A dark den that smells of goblin', -1, 1, 2, -1, ['Goblin'])
  room1 = Room.new('Jungle', 'A tropical enclosure with whistling birds', -1, -1, -1, 0, ['Tree', 'Faerie'])
  room2 = Room.new('Cave', 'A spherical cave covered with ivy', 0, 3, -1, -1, ['Obelisk'])
  room3 = Room.new('Crypt', 'A gloomy crypt with diseased rats', -1, -1, -1, 2, ['Rat']*4)
  map = [room0, room1, room2, room3]
  map
end

def move_player(dirshort, dirlong)
  unless @world_map[@user.location].send(dirshort) == -1 
    @user.move_player(@world_map[@user.location].send(dirshort))
    puts("You moved #{dirlong}!")
    puts(@world_map[@user.location])
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
    @user.look(@world_map)
  when COMMANDS[:debug]
    byebug
  when COMMANDS[:scan]
    @user.scan(@world_map)
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
  s = "Welcome, #{@user.name}. What would you like to do? You're in #{@world_map[@user.location]}"
  puts(s)
  loop do
    print("> ")
    input = gets
    # TODO: make this do shit
    output = run_command(input)
    puts(output)
  end
end


@user = Player.new('Adventurer', 0, 15, 15, 15)
@goblin = Player.new('Goblin', 1, 15, 15, 15)
@world_map = build_map
start_game