module Shield::RegisterEmailConfirmationUser
  macro included
    attribute password : String

    after_save set_email_confirmation_user
    after_save end_email_confirmations

    include Shield::SetEmailFromEmailConfirmation
    include Shield::SaveEmail
    include Shield::CreatePassword
    include Shield::DeleteSession(EmailConfirmationSession)

    private def set_email_confirmation_user(user : User)
      EmailConfirmationQuery.new
        .id(email_confirmation.id)
        .update(user_id: user.id)
    end

    private def end_email_confirmations(user : User)
      EmailConfirmationQuery.new
        .email(user.email)
        .active
        .update(ended_at: Time.utc)
    end
  end
end
