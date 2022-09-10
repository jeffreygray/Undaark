#!/usr/bin/env ruby

require_relative 'room'
require 'pry'

# Why couldn't I call this without ()
def BuildMap                                                            #    N   E   S   W
  room0 = Room.new('Goblin\'s Lair', 'A dark den that smells of goblin', -1, 1, 2, -1)
  room1 = Room.new('Jungle', 'A tropical enclosure with whistling birds', -1, -1, -1, 0)
  room2 = Room.new('Cave', 'A spherical cave covered with ivy', 0, 3, -1, -1)
  room3 = Room.new('Crypt', 'A gloomy crypt with diseased rats', -1, -1, -1, 2)
  map = [room0, room1, room2, room3]
  map
end

def StartGame
  input = ''
  output = ''
  s = 'Welcome, adventurer. What would you like to do?'
  puts(s)
  # Game Loop 
  loop do
    print("> ")
    input = gets
    # TODO: make this do shit
    #output = run_command(input)
    puts(output)
    break if input.strip.downcase == 'quit'
    binding.pry if input.strip.downcase == 'debug'
  end
end

if __FILE__ == $PROGRAM_NAME
  @world_map = BuildMap()
  StartGame()
end


