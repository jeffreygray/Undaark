class Thing
    attr_accessor :name, :description

    def initialize(params)
        @name = params[:name] 
        @description = params[:description] || ""
    end

    def fights?
        false
    end

    def climbable?
        false
    end

    def openable?
      false
    end
end
