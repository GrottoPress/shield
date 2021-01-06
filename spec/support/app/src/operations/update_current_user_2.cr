require "./save_user_options_2"

class UpdateCurrentUser2 < User::SaveOperation
  include Shield::UpdateUser
  # include Shield::NotifyPasswordChange

  has_one save_user_options : SaveUserOptions2

  before_save set_level

  private def set_level
    level.value = User::Level.new(:author)
  end
end
