module Generators

  PLACE_ADJECTIVES = %w[
    dark
    tropical
    spherical
    gloomy
    dusty
    muddy
  ].freeze

  PLACES = %w[
    den
    enclosure
    cave
    crypt
    tomb
    lair
    crevice
    jungle
    icehouse
    desert
    oasis
    mine
  ].freeze

  THING_ADJECTIVES = %w[
    decrepit
    whistling
    diseased
    skeletal
    dilapidated
    poisonous
    old
    hollow
  ].freeze

  THINGS = %w[
    rats
    birds
    ivy
    bones
    chests
    dirt
    columns
    coffins
  ].freeze

  PREPOSITIONS = %w[
    with
  ].freeze

  class Room

    def self.build(count)
      rooms = []

      count.times do
        place     = PLACES.sample
        place_adj = PLACE_ADJECTIVES.sample
        thing     = THINGS.sample
        thing_adj = THING_ADJECTIVES.sample
        prep      = PREPOSITIONS.sample

        description = "A #{place_adj} #{place} #{prep} #{thing_adj} #{thing}"

        rooms << ::Room.new(place.capitalize, description)
      end

      rooms
    end

  end

end
