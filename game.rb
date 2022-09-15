#!/usr/bin/env ruby

# TODO:

# initialize random number generator with seed
# Nightmare event randomly during game tic?
# Reconsider Input handling part of the player class instead of in game?

# room traps , doors getting shut, doors locked will have the -2 added
# quicksand, try to leave a few times before you  get out

require_relative 'room'
require_relative 'things/player'
require_relative 'world_map'
require_relative 'generators/room'
require 'byebug'


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

class Game

  def initialize()
    @player = Player.new('Adventurer', 0, 15, 15, 15)
    @goblin = Player.new('Goblin', 1, 15, 15, 15)
    @world_map = WorldMap.new
  end

  def move_player(dirshort)
    if @world_map.can_move_from_to(@player.instance, @player.location, dirshort)
      @player.move_player(@world_map.move_from_to(@player.instance, @player.location, dirshort))
      true
    else
      false
    end
  end

  def get_player_room
    @world_map.get_room(@player.instance, @player.location)
  end

  def player_look
    @player.look(@world_map.get_room(@player.instance, @player.location))
  end

  def climb_rope
    if ["Dungeon Entrance", "Dungeon Vault"].include? get_player_room.name
      @player.leave_instance
      true
    else
      false
    end
  end

  def enter_dungeon
    if @player.is_in_instance
      # already in a dungeon
      false
    else
      @player.enter_instance(@world_map.build_dungeon(5, 0))
    end
  end

  def player_adjacent_rooms
    @world_map.adjacent_rooms(@player.instance, @player.location)
  end
end
