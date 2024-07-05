module Shield::UpdateEmailConfirmationUser # User::SaveOperation
  macro included
    getter new_email : String?
    getter credentials : EmailConfirmationCredentials?

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
        operation = StartEmailConfirmation.new(
          user_id: user.id,
          email: email,
          remote_ip: remote_ip
        )

        @credentials = EmailConfirmationCredentials.new(
          operation,
          operation.save!
        )
      end
    end
  end
end
