require "./save_user_options_2"

class RegisterEmailConfirmationCurrentUser2 < User::SaveOperation
  include Shield::RegisterEmailConfirmationUser
  # include Shield::SendWelcomeEmail

  has_one_create save_user_options : SaveUserOptions2, assoc_name: :options

  before_save set_level

  private def set_level
    level.value = User::Level.new(:author)
  end
end
