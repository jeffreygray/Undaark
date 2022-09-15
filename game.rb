#!/usr/bin/env ruby

# Change to server 

# TODO:

# quicksand, try to leave a few times before you  get out
# room traps , doors getting shut, doors locked will have the -2 added
# Make look show desc from thing
# Nightmare event randomly during game tic?


require_relative 'room'
require_relative 'things/player'
require_relative 'world_map'
require_relative 'generators/room'
require_relative 'things/thing'
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

  attr_accessor :player, :world_map

  def initialize()
    # thing:   name = nil, description = nil)
    # player: location = 0, str = 15, dex = 15, int = 15)
    player_params = {
      name: 'Adventurer',
      location: 0,
      str: 15,
      dex: 15,
      int: 15
    }.freeze
    @player = Player.new(player_params)
   # @goblin = Player.new('Goblin', 1, 15, 15, 15)
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

  def enter_dungeon(seed = nil)
    if @player.is_in_instance
      # already in a dungeon
      false
    else
      if seed == nil
        @player.enter_instance(@world_map.build_dungeon(5))
      else
        @player.enter_instance(@world_map.build_dungeon(5, seed))
      end
    end
  end

  def player_adjacent_rooms
    @world_map.adjacent_rooms(@player.instance, @player.location)
  end
end
