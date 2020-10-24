module Shield::UpdateEmailConfirmationUser
  macro included
    include Shield::UpdateUser

    getter new_email : String?

    needs remote_ip : Socket::IPAddress?

    before_save do
      set_email
    end

    after_save start_email_confirmation

    private def set_email
      return unless email.changed?

      @new_email = email.value
      email.value = email.original_value
    end

    private def start_email_confirmation(user : User)
      new_email.try do |email|
        StartEmailConfirmation.create!(
          user_id: user.id,
          email: email,
          remote_ip: remote_ip
        )
      end
    end
  end
end
