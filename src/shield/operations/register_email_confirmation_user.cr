module Shield::RegisterEmailConfirmationUser
  macro included
    attribute password : String

    after_completed set_email_confirmation_user
    after_completed end_email_confirmations

    include Shield::SetEmailFromEmailConfirmation
    include Shield::SaveEmail
    include Shield::CreatePassword
    include Shield::DeleteSession

    private def set_email_confirmation_user(user : User)
      EmailConfirmationQuery.new
        .id(email_confirmation.id)
        .update(user_id: user.id)
    end

    private def end_email_confirmations(user : User)
      EmailConfirmationQuery.new
        .email(user.email)
        .is_active
        .update(ended_at: Time.utc)
    end

    private def delete_session(user : User)
      session.try { |session| EmailConfirmationSession.new(session).delete }
    end
  end
end
