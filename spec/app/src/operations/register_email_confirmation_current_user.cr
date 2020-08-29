require "./save_user_options"

class RegisterEmailConfirmationCurrentUser < User::SaveOperation
  include Shield::RegisterEmailConfirmationUser

  before_save set_level

  private def set_level
    level.value = User::Level.new(:author)
  end
end
