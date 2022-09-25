#!/usr/bin/env ruby

# Change to server

# TODO:

# Make look show desc from thing. add desc to thing.to_s?
# entity class enemy,player < entity < thing (since they share some attribs)
# Nightmare event randomly during game tic?
# List enemies command: don't know the syntax - attack ? ?
#
# implement puzzle room
# something to spend cash on
#
# player equipment
# health
#
# client/server
# persistence (db)
# player profiles
# player logins
# multiple players

require_relative 'room'
require_relative 'things/player'
require_relative 'things/enemy'
require_relative 'things/rope'
require_relative 'things/chest'
require_relative 'world_map'
require_relative 'generators/room'
require_relative 'quicksand_room'
require 'byebug'
require 'json'

OPPOSITE = {
  north: :south,
  south: :north,
  east:  :west,
  west:  :east
}.freeze

DIRS = %i[
  north
  south
  east
  west
].freeze

class Server

  attr_accessor :player, :world_map

  def initialize
    # thing:   name = nil, description = nil)
    # player: location = 0, str = 15, dex = 15, int = 15)
    player_params = {
      name:     'Adventurer',
      location: 0,
      str:      15,
      dex:      15,
      int:      15
    }.freeze
    @players = Hash.new #Things::Player.new(player_params)
    # @goblin = Things::Player.new('Goblin', 1, 15, 15, 15)
    @world_map = WorldMap.new
    @endpoint = ENDPOINT
    @server = start_server(@endpoint)
  end

  def start_server(endpoint)
    Async do |task|
      endpoint.accept do |client|
        data = client.read
        resp = run_command(data.downcase.split(" "))
        client.write(resp)
        client.close_write
      end
    end
  end

  def run_command(args)
    case args[1]
    when 'init_player'
      return init_player(args[0]).name.to_s
    when 'get_player_room'
      return get_player_room(args[0]).to_s
    when 'move'
      return move_player(args[2], args[0]).join(";").to_s
    when 'look'
      return player_look(args[0]).to_s
    when 'climb_rope'
      return climb_rope(args[0]).to_s
    when 'enter_dungeon'
      return enter_dungeon(args[0]).to_s
    when 'open_chest'
      return open_chest(args[0]).join(";").to_s
    when 'player_adjacent_rooms'
      return player_adjacent_rooms(args[0]).map do |room|
        room[1].nil? ? "nil" : room[1].to_s
      end.join(";")
    when 'attack'
      return perform_attack(args[0], args[2], args[3]).join(";").to_s
    end
    "SUCCESS I GUESS"
  end

  def init_player(player_id)
    player_params = {
      name:     'Adventurer',
      location: 0,
      str:      15,
      dex:      15,
      int:      15
    }.freeze
    if @players.key?(player_id)
      @players[player_id]
    else
      @players[player_id] = Things::Player.new(player_params)
    end
    byebug
    return @players[player_id]
  end

  def move_player(dirshort, player_id)
    if @world_map.can_move_from_to(@players[player_id].instance, @players[player_id].location, dirshort)
      get_player_room(player_id).objects.delete(@players[player_id])
      @players[player_id].move_player(@world_map.move_from_to(@players[player_id].instance, @players[player_id].location, dirshort))
      get_player_room(player_id).objects << @players[player_id]
      @players[player_id].struggle_attempts = 0
      [true, get_player_room(player_id).reanimate_undead]
    elsif get_player_room(player_id).has_combat
      [false, 'you try to leave but evil blocks your path!']
    elsif get_player_room(player_id).is_a? QuicksandRoom
      if get_player_room(player_id).is_locked
        @players[player_id].struggle_attempts += 1
        [false, "You try to move but you're stuck in quicksand!"]
      else
        [false, "You can't move that way!"]
      end
    else
      [false, "You can't move that way!"]
    end
  end

  def get_player_room(player_id)
    @world_map.get_room(@players[player_id].instance, @players[player_id].location)
  end

  def player_look(player_id)
    @players[player_id].look(get_player_room(player_id))
  end

  def perform_attack(player_id, enemy_name, attack)
    result = 0
    atk_conv = {
      club:  'rock',
      slice: 'scissors',
      cover: 'paper'
    }
    if !atk_conv.include? attack.to_sym
      return [false, 'invalid attack option']
    end

    player_rps = atk_conv[attack.to_sym]

    enemy = get_player_room(player_id).get_enemy enemy_name
    if enemy.nil?
      return [false, "no #{enemy_name} enemy present"]
    end

    adv = {
      rock:     'scissors',
      scissors: 'paper',
      paper:    'rock'
    }
    if adv[player_rps.to_sym] == enemy.attack
      result = 1  # win
    elsif adv[enemy.attack.to_sym] == player_rps
      result = -1 # loss
    end
    msg = ''
    case result
      when 1
        if !enemy.undead
          get_player_room(player_id).desc += ', stone cold dead'
        end
        msg = "#{@players[player_id].name} #{attack}s the enemy #{enemy.name}... the #{enemy.name} is defeated!"
        enemy.defeat
        msg
      when -1
        msg = "#{@players[player_id].name} falls to the enemy #{enemy.name}'s attack!"
      else
        msg = "#{@players[player_id].name} clashes with the #{enemy.name} but the fight continues!"
    end
    [true, msg]
  end

  def climb_rope(player_id)
    if get_player_room(player_id).has_rope
      @players[player_id].leave_instance
      true
    else
      false
    end
  end

  def enter_dungeon(player_id, seed = nil)
    if @players[player_id].is_in_instance
      # already in a dungeon
      false
    elsif seed.nil?
      @players[player_id].enter_instance(@world_map.build_dungeon(4))
    else
      @players[player_id].enter_instance(@world_map.build_dungeon(4, seed))
    end
  end

  def open_chest(player_id)
    chest = get_player_room(player_id).get_thing('Chest')
    msg = ''
    if chest.nil?
      return [false, 'there is no chest present']
    elsif chest.closed
      msg = "#{@players[player_id].name} finds #{chest.loot} cash in the chest!"
      chest.open(@players[player_id])
      msg += "\n#{@players[player_id].name} now has #{@players[player_id].cash} cash"
      return [true, msg]
    else
      return [false, 'that chest has already been opened']
    end
  end

  def player_adjacent_rooms(player_id)
    @world_map.adjacent_rooms(@players[player_id].instance, @players[player_id].location)
  end

end

Server.new
