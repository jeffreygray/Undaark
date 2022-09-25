module Things

  class Rope < Thing

    def initialize(params)
      params[:name] ||= 'Rope'
      super(params)
    end

    def climbable?
      true
    end

    def to_s
      "a rope"
    end

  end

end
