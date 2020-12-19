class UpdateEmailConfirmationCurrentUser2 < User::SaveOperation
  include Shield::UpdateEmailConfirmationUser

  has_one_update save_user_options : SaveUserOptions2, assoc_name: :options

  before_save set_level

  private def set_level
    level.value = User::Level.new(:author)
  end
end
