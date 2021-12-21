module Shield::UpdateEmailConfirmationUser
  macro included
    getter email_confirmation : EmailConfirmation?
    getter new_email : String?
    getter start_email_confirmation : StartEmailConfirmation?

    needs remote_ip : Socket::IPAddress?

    after_save start_email_confirmation

    include Shield::UpdateUser

    before_save do
      revert_email
    end

    private def validate_email_unique
    end

    private def revert_email
      return unless email.changed?

      @new_email = email.value
      email.value = email.original_value
    end

    private def start_email_confirmation(user : Shield::User)
      new_email.try do |email|
        @start_email_confirmation = StartEmailConfirmation.new(
          user_id: user.id,
          email: email,
          remote_ip: remote_ip
        )

        @email_confirmation = @start_email_confirmation.try(&.save!)
      end
    end
  end
end
