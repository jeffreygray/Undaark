class QuicksandRoom < Room

  def is_locked
    @objects.each do |object|
      if object.is_a?(Things::Player) && (object.struggle_attempts < 3)
        return true
      end
    end
    false
  end

end
