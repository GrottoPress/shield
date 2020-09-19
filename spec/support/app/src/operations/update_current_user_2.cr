require "./save_user_options_2"

class UpdateCurrentUser2 < User::SaveOperation
  include Shield::SaveEmail
  include Shield::UpdatePassword

  permit_columns :email

  attribute password : String
  attribute password_confirmation : String

  has_one_update save_user_options : SaveUserOptions2, assoc_name: :options

  before_save set_level

  private def set_level
    level.value = User::Level.new(:author)
  end
end
