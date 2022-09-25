#!/usr/bin/env ruby

require_relative 'constants'
require 'byebug'

# vars, etc

def move_player(dirshort)
  send_command(['move',dirshort], -> (result) do
    result = result.split(";")
    if result[0] == "true"
      puts("You moved #{dirshort}!")
      if result[1] != ''
        puts(result[1])
      end
      get_player_room(-> (resp) do
        puts(resp)
        request_input()        
      end)
    else
      puts(result[1])
      request_input()
    end
  end)
end

def is_valid_attack(attack)
  return %w[club slice cover].include? attack
end

def run_command(input)
  if !input
    input = QUIT
  end
  inputArr = input.downcase.split(' ')
  if inputArr.length.zero?
    return
  end

  case COMMANDS[inputArr[0].strip.to_sym]
    when ''
      return
    when ATTACK
      if inputArr.length != 3
        puts('You must choose an enemy and an attack! That is all!')
      elsif !is_valid_attack(inputArr[2])
        puts('You may only club, slice, or cover your opponent!')
      else
        perform_attack(inputArr[1], inputArr[2], -> (resp) do
          resp = resp.split(";")
          if resp[0]
            puts(resp[1])
          else
            puts("Error: #{resp[1]}")
          end
          request_input()
        end)
      end
    when NORTH
      move_player(NORTH)
    when EAST
      move_player(EAST)
    when SOUTH
      move_player(SOUTH)
    when WEST
      move_player(WEST)
    when LOOK
      look(-> (resp) do 
        puts(resp)
        request_input()
      end)
    when CLIMB_ROPE
      climb_rope(-> (resp) do 
        if resp
          get_player_room(-> (resp2) do
            puts("You climb the rope back up to the #{resp2}")
            request_input()
          end)
        else
          puts("There's no rope here to climb")
          request_input()
        end
      end)
    when ENTER
      enter_dungeon(-> (resp) do
        if(resp)
          puts('You entered a new dungeon!')
          get_player_room(-> (resp2) do
            puts(resp2)
            request_input()
          end)
        else
          puts("You can't enter a dungeon here")
          request_input()
        end
      end)
    when OPEN
      open_chest(-> (resp) do
        resp = resp.split(";")
        if resp[0] == "true"
          puts(resp[1])
        else
          puts("Error: #{resp[1]}")
        end
        request_input()
      end)
    when DEBUG
      puts("Entering debug mode, use 'pw' to print the world")
      byebug
      request_input()
    when SCAN
      scan
    when QUIT
      puts('Quitting the game...')
      exit
    else
      puts("#{input} unrecognized... please try another command.")
      request_input()
  end
end

def perform_attack(enemy, attack, callback = nil)
  send_command(['attack',enemy, attack], callback)
end

def scan
  send_command(['player_adjacent_rooms'], -> (adj) do
    adj = adj.split(";")
    s = ''
    # roll dice related to some future perception check, you see a "room.name"
    s += "North of you, you see: #{adj[0]}\n" if adj[0] != "nil"
    s += "To the east, you see: #{adj[1]}\n" if adj[1] != "nil"
    s += "Towards the south, you see: #{adj[2]}\n" if adj[2] != "nil"
    s += "As you look westward, you see: #{adj[3]}\n" if adj[3] != "nil"
    puts("#{s}\n")
    request_input()
  end)
end

def look(callback = nil)
  send_command(['look'], callback)
end

def climb_rope(callback = nil)
  send_command(['climb_rope'], callback)
end

def enter_dungeon(callback = nil)
  send_command(['enter_dungeon'], callback)
end

def get_player_room(callback = nil)
  send_command(['get_player_room'], callback)
end

def open_chest(callback = nil)
  send_command(['open_chest'], callback)
end

def init_player(callback = nil)
  send_command(['init_player'], callback)
end

# Game Loop
def start_game
  init_player(-> (name) do
    @name = name
    get_player_room(-> (location) do
      location = if 'aeiou'.include? location.to_s.downcase[0]
          "an #{location}"
        else
          "a #{location}"
        end
      puts("Welcome, #{@name}. What would you like to do? You are in #{location}")
      request_input()
    end)
  end)
#  loop do
#    print('> ')
#    input = gets
#    # TODO: make this do shit
#    # For server, we need to decide how and when data gets sent to the server. For now I'm going to make the wait blocking until we decide
#    output = run_command(input)
#    puts(output)
#  end
end

def request_input()
  print('> ')
  input = STDIN.gets
  run_command(input)
end

def send_command(data, callback)
  Async do |task|
    @endpoint.connect do |peer|
      data.unshift(ARGV[0])
      peer.write(data.join(" "))
      peer.close_write
      resp = peer.read
      if(callback)
        callback.call(resp)
      end
    end
  end
end

@endpoint = ENDPOINT
start_game
