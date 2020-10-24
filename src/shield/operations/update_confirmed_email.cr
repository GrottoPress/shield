module Shield::UpdateConfirmedEmail
  macro included
    after_save end_email_confirmations

    include Shield::SetEmailFromEmailConfirmation
    include Shield::SaveEmail
    include Shield::DeleteSession(EmailConfirmationSession)

    private def end_email_confirmations(user : User)
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
