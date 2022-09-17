require 'byebug'
require_relative 'thing'

class Player < Thing
  attr_accessor :location, :instance, :str, :dex, :int, :struggle_attempts, :cash

  def initialize(params)
    super # TODO: for Jeff, find out why this works and isn't in byebug/pry
    @location = params[:location] || 0
    @instance = params[:instance] || 0
    @return_location = params[:return_location] || nil
    @str = params[:str]
    @dex = params[:dex]
    @int = params[:int]
    @struggle_attempts = 0
    @cash = 0
  end

  def enter_instance(instance)
    @return_location = @location
    @instance = instance
    move_player(0)
  end

  def leave_instance
    if @return_location == nil
      puts("There's no instance to exit")
    elsif
      move_player(@return_location)
      @return_location = nil
      @instance = 0
    end
  end

  def is_in_instance
      @return_location != nil
  end

  def move_player(newroom)
    @location = newroom
  end

  def look(room)
    s = "In a #{room.name}, you see:\n\n"
    saw_something = false
    room.objects.each do |object| # Note: iterating
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
