module Shield::UpdateConfirmedEmail
  macro included
    after_save end_email_confirmations

    include Shield::SetEmailFromEmailConfirmation
    include Shield::SaveEmail
    include Shield::DeleteSession(EmailConfirmationSession)

    private def end_email_confirmations(user : User)
      EmailConfirmationQuery.new
        .email(user.email)
        .active
        .update(ended_at: Time.utc)
    end
  end
end
