require 'byebug'

class Player
  attr_accessor :name, :location, :instance, :str, :dex, :int

  def initialize(name = nil, location = 0, str = 15, dex = 15, int = 15)
    @name = name
    @location = location
    @instance = 0
    @overworld = nil
    @str = str
    @dex = dex
    @int = int
  end

  def enter_instance(instance)
    @overworld = @location
    @instance = instance
    move_player(0)
  end

  def leave_instance
    if @overworld == nil
      puts("There's no instance to exit")
    elsif
      move_player(@overworld)
      @overworld = nil
      @instance = 0
    end
  end

  def is_in_instance
    @overworld != nil
  end

  def move_player(newroom)
    @location = newroom
  end

  def look(room)
    s = "In a #{room.name}, you see:\n\n"
    room.objects.each do |object| # Note: iterating
      s += "#{object}\n"
    end
    "#{s}\n"
  end

  def scan(adj)
    s = ''
    #byebug
    # roll dice related to some future perception check, you see a "room.name"
    s += "North of you, you see: #{adj[:north].name}\n" if adj[:north]
    s += "To the east, you see: #{adj[:east].name}\n" if adj[:east]
    s += "Towards the south, you see: #{adj[:south].name}\n" if adj[:south]
    s += "As you look westward, you see: #{adj[:west].name}\n" if adj[:west]
    "#{s}\n"
  end

end
