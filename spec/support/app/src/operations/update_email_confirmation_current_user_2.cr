class UpdateEmailConfirmationCurrentUser2 < User::SaveOperation
  include Shield::SaveEmail
  include Shield::UpdatePassword

  getter new_email : String?

  permit_columns :email

  attribute password : String
  attribute password_confirmation : String

  has_one_update save_user_options : SaveUserOptions2, assoc_name: :options

  needs remote_ip : Socket::IPAddress?

  before_save do
    set_email
    set_level
  end

  after_save start_email_confirmation

  private def set_email
    return unless email.changed?

    @new_email = email.value
    email.value = email.original_value
  end

  private def set_level
    level.value = User::Level.new(:author)
  end

  private def start_email_confirmation(user : User)
    new_email.try do |email|
      StartEmailConfirmation.submit!(
        user_id: user.id,
        email: email,
        remote_ip: remote_ip
      )
    end
  end
end
