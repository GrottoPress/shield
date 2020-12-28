module Shield::UpdateEmailConfirmationUser
  macro included
    getter new_email : String?

    getter email_confirmation : EmailConfirmation?
    getter start_email_confirmation : StartEmailConfirmation?

    permit_columns :email

    attribute password : String

    needs remote_ip : Socket::IPAddress?

    before_save do
      validate_required email
      validate_email email

      reset_email
    end

    after_save start_email_confirmation

    after_completed do |saved_record|
      start_email_confirmation(saved_record) if changes.empty?
    end

    include Shield::UpdatePassword

    private def reset_email
      return unless email.changed?

      @new_email = email.value
      email.value = email.original_value
    end

    private def start_email_confirmation(user : User)
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
