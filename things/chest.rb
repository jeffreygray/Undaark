module Things
  class Chest < Thing

    attr_accessor :loot, :closed

    def initialize(params)
      params[:name] ||= 'Chest'
      super(params)
      @loot = params[:loot] || 0
      @closed = true
    end

    def openable?
      true
    end

    def open(player)
      cash = @loot
      @loot = 0   # set this before giving to player to prevent any weird exploits
      @closed = false
      player.cash += cash
    end

  end

end
