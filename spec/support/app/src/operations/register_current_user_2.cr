require "./save_user_options_2"

class RegisterCurrentUser2 < User::SaveOperation
  include Shield::RegisterEmailConfirmationUser

  has_one save_user_options : SaveUserOptions2

  before_save set_level

  private def set_level
    level.value = User::Level.new(:author)
  end
end
