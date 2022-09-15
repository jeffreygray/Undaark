require_relative 'thing'

class Enemy < Thing
    
    # To be replaced.
    ROCK = 'rock'
    PAPER = 'paper'
    SCISSORS = 'scissors'

    ROCK_FLAVOR = [
        "The # looks to bolder you over",
        "It seems the # has a chip on it\'s shoulder",
        "This # is a stone cold killer"
    ].freeze;

    SCISSORS_FLAVOR = [
        "This # is a cut above the rest",
        "The # appears to be very snippy",
        "This # is looking sharp!"
    ].freeze

    PAPER_FLAVOR = [
        "The #\'s face is as blank as a page",
        "The # looks ready to jump into the fold!",
        "Beware the tearable nature of the #"
    ].freeze

    def initialize(params)
        super
        @location = params[:location] || 0
        @instance = params[:instance] || 0
        @combat_preference = params[:combat_preference] || ROCK
    end

    def fights?
        true
    end

    def attack
        @combat_preference
    end

    def to_s
        flavor = []
        case @combat_preference
        when ROCK
            flavor = ROCK_FLAVOR
        when PAPER
            flavor = PAPER_FLAVOR
        when SCISSORS
            flavor = SCISSORS_FLAVOR
        end
        "#{name}\n#{flavor[rand(0..2)].sub("#","#{name}")}"
    end


end
