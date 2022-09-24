require 'async/io'

HOST='127.0.0.1'.freeze
PORT=9000.freeze
ENDPOINT=Async::IO::Endpoint.tcp(HOST,PORT).freeze


NORTH = 'north'.freeze
EAST = 'east'.freeze
SOUTH = 'south'.freeze
WEST = 'west'.freeze
QUIT = 'quit'.freeze
LOOK = 'look'.freeze
SCAN = 'scan'.freeze
ENTER = 'enter'.freeze
CLIMB_ROPE = 'climb-rope'.freeze
ATTACK = 'attack'.freeze
OPEN = 'open'.freeze
DEBUG = 'debug'.freeze

COMMANDS = { # constant-ish (frozen hash)
  north:         NORTH,
  n:             NORTH,
  east:          EAST,
  e:             EAST,
  south:         SOUTH,
  s:             SOUTH,
  west:          WEST,
  w:             WEST,
  quit:          QUIT,
  q:             QUIT,
  look:          LOOK,
  "look around": LOOK,
  scan:          SCAN,
  enter:         ENTER,
  climb:         CLIMB_ROPE,
  "climb rope":  CLIMB_ROPE,
  attack:        ATTACK,
  open:          OPEN,
  debug:         DEBUG # remove me ree!
}.freeze
