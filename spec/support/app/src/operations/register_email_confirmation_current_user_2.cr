require "./save_user_options_2"

class RegisterEmailConfirmationCurrentUser2 < User::SaveOperation
  attribute password : String
  attribute password_confirmation : String

  has_one_create save_user_options : SaveUserOptions2, assoc_name: :options

  before_save set_level

  include Shield::SetEmailFromEmailConfirmation
  include Shield::SaveEmail
  include Shield::CreatePassword
  include Shield::DeleteSession(EmailConfirmationSession)

  private def set_level
    level.value = User::Level.new(:author)
  end
end
