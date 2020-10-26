require "./save_user_options"

class UpdateCurrentUser < User::SaveOperation
  include Shield::UpdateUser
  include Shield::HasOneUpdateSaveUserOptions
  include Shield::NotifyPasswordChange

  before_save set_level

  private def set_level
    level.value = User::Level.new(:author)
  end
end
