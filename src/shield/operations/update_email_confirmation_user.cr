module Shield::UpdateEmailConfirmationUser
  macro included
    getter new_email : String?

    getter email_confirmation : EmailConfirmation?
    getter start_email_confirmation : StartEmailConfirmation?

    needs remote_ip : Socket::IPAddress?

    before_save do
      reset_email
    end

    after_save start_email_confirmation

    include Shield::UpdateUser

    private def reset_email
      return unless email.changed?

      @new_email = email.value
      email.value = email.original_value
    end

    private def start_email_confirmation(user : User)
      new_email.try do |email|
        StartEmailConfirmation.create(
          user_id: user.id,
          email: email,
          remote_ip: remote_ip
        ) do |operation, email_confirmation|
          unless operation.user_email?
            @email_confirmation = email_confirmation.not_nil!
            @start_email_confirmation = operation
          end
        end
      end
    rescue NilAssertionError
      raise Avram::Rollback.new
    end
  end
end
