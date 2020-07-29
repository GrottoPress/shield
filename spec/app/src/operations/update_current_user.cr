require "./save_user_options"

class UpdateCurrentUser < User::SaveOperation
  include Shield::UpdateUser

  before_save set_level

  private def set_level
    level.value = User::Level.new(:author)
  end
end
