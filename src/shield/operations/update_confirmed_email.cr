module Shield::UpdateConfirmedEmail
  macro included
    after_save end_email_confirmations

    include Shield::SetEmailFromEmailConfirmation
    include Shield::SaveEmail
    include Shield::DeleteSession

    private def end_email_confirmations(user : Shield::User)
      EmailConfirmationQuery.new
        .email(user.email)
        .is_active
        .update(inactive_at: Time.utc)
    end

    private def delete_session(user : Shield::User)
      session.try { |session| EmailConfirmationSession.new(session).delete }
    end
  end
end
