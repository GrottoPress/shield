class SaveUserOptions2 < UserOptions::SaveOperation
  include Shield::SaveUserOptions

  before_save error_on_purpose

  private def error_on_purpose
    login_notify.add_error "has failed on purpose"
    password_notify.add_error "has failed on purpose"
  end
end
