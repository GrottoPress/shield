class UpdateCurrentUser < User::SaveOperation
  before_save set_level

  private def set_level
    level.value = User::Level.new(:author)
  end
end
