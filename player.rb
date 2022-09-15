require 'byebug'

class Player
  attr_accessor :name, :location, :instance, :str, :dex, :int, :struggle_attempts

  def initialize(name = nil, location = 0, str = 15, dex = 15, int = 15)
    @name = name
    @location = location
    @instance = 0
    @overworld = nil
    @str = str
    @dex = dex
    @int = int
    @struggle_attempts = 0
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
    saw_something = false
    room.objects.each do |object| # Note: iterating
      # don't return the player itself
      if object == self
        next
      end
      saw_something = true
      s += "#{object}\n"
    end
    if saw_something
      "#{s}\n"
    else
      "#{s}Nothing\n\n"
    end
  end

end
