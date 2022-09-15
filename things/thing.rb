class Thing
    attr_accessor :name, :description

    def initialize(name = nil, description = nil)
        @name = name
        @description = description
    end
end
