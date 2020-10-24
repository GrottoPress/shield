module Shield::RegisterEmailConfirmationUser
  macro included
    attribute password : String
    attribute password_confirmation : String

    has_one_create save_user_options : SaveUserOptions, assoc_name: :options

    after_save end_email_confirmations

    include Shield::SetEmailFromEmailConfirmation
    include Shield::SaveEmail
    include Shield::CreatePassword
    include Shield::DeleteSession(EmailConfirmationSession)

    private def end_email_confirmations(user : User)
      EmailConfirmationQuery.new
        .id(email_confirmation.id)
        .update(user_id: user.id)

      EmailConfirmationQuery.new
        .email(user.email)
        .status(EmailConfirmation::Status.new :started)
        .update(
          ended_at: Time.utc,
          status: EmailConfirmation::Status.new(:ended)
        )
    end
  end
end
