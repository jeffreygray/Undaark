require_relative 'thing'

class Rope < Thing

  def initialize(params)
    params[:name] ||= 'Rope'
    super(params)
  end

  def climbable?
    true
  end

end
