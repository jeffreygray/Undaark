require_relative 'thing'

class Rope < Thing
    def initialize(params)
        super(params)
    end

    def climbable?
        true
    end
end
