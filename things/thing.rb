class Thing
    attr_accessor :name, :description

    def initialize(params)
        @name = params[:name] 
        @description = params[:description] || ""
    end
end
