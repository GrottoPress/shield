module Shield::UpdateEmailConfirmationUser
  macro included
    getter new_email : String?

    getter email_confirmation : EmailConfirmation?
    getter start_email_confirmation : StartEmailConfirmation?

    permit_columns :email

    attribute password : String

    needs remote_ip : Socket::IPAddress?

    before_save do
      validate_email_required
      validate_email_valid

      reset_email
    end

    after_save start_email_confirmation

    include Shield::UpdatePassword

    private def validate_email_required
      validate_required email,
        message: Rex.t(:"operation.error.email_required")
    end

    private def validate_email_valid
      validate_email email, message: Rex.t(
        :"operation.error.email_invalid",
        email: email.value
      )
    end

    private def reset_email
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
