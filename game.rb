#!/usr/bin/env ruby

# Change to server 

# TODO:

# Make look show desc from thing
# Nightmare event randomly during game tic?
#
# implement puzzle room
#
# player equipment
# after things:
  # dungeon vaults
  # combat
    # health
#
# client/server
# multiple players

require_relative 'room'
require_relative 'things/player'
require_relative 'things/enemy'
require_relative 'things/rope'
require_relative 'world_map'
require_relative 'generators/room'
require_relative 'quicksand_room'
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
      get_player_room.objects.delete(@player)
      @player.move_player(@world_map.move_from_to(@player.instance, @player.location, dirshort))
      get_player_room.objects << @player
      @player.struggle_attempts = 0
      [true, get_player_room.reanimate_undead]
    else
      if get_player_room.has_combat
          [false, "you try to leave but evil blocks your path!"]
      elsif get_player_room.is_a? QuicksandRoom
        if get_player_room.is_locked
          @player.struggle_attempts += 1
          [false, "You try to move but you're stuck in quicksand!"]
        else
          [false, "You can't move that way!"]
        end
      else
        [false, "You can't move that way!"]
      end
    end
  end

  def get_player_room
    @world_map.get_room(@player.instance, @player.location)
  end

  def player_look
    @player.look(get_player_room)
  end

  def perform_attack(enemy_name, attack)
    result = 0
    atk_conv = {
      club: 'rock',
      slice: 'scissors',
      cover: 'paper'
    }
    if not atk_conv.include? attack.to_sym
      return [false, "invalid attack option"]
    end
    player_rps = atk_conv[attack.to_sym]

    enemy = get_player_room.get_enemy enemy_name
    if enemy == nil
      return [false, "no #{enemy_name} enemy present"]
    end

    adv = {
      rock: 'scissors',
      scissors: 'paper',
      paper: 'rock'
    }
    if adv[player_rps.to_sym] == enemy.attack
      result = 1  # win
    elsif adv[enemy.attack.to_sym] == player_rps
      result = -1 # loss
    end
    msg = ""
    if result == 1
        if !enemy.undead
          get_player_room.desc += ", stone cold dead"
        end
        msg = "#{@player.name} #{attack}s the enemy #{enemy.name}... the #{enemy.name} is defeated!"
        enemy.defeat
        msg
    elsif result == -1
        msg = "#{@player.name} falls to the enemy #{enemy.name}'s attack!"
    else
        msg = "#{@player.name} clashes with the #{enemy.name} but the fight continues!"
    end
    [true, msg]
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
