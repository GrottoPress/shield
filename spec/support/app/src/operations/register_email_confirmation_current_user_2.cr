require "./save_user_options_2"

class RegisterEmailConfirmationCurrentUser2 < User::SaveOperation
  include Shield::SaveEmail
  include Shield::CreatePassword

  attribute password : String
  attribute password_confirmation : String

  needs session : Lucky::Session

  has_one_create save_user_options : SaveUserOptions2, assoc_name: :options

  before_save set_level

  after_save delete_session

  private def set_level
    level.value = User::Level.new(:author)
  end

  private def delete_session(user : User)
    EmailConfirmationSession.new(session).delete
  end
end
