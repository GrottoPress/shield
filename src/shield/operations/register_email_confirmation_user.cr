module Shield::RegisterEmailConfirmationUser
  macro included
    needs session : Lucky::Session?

    attribute password : String

    after_save end_email_confirmation
    after_save end_email_confirmations

    include Shield::SetEmailFromEmailConfirmation
    include Shield::SetPasswordDigestFromPassword
    include Shield::ValidateUser

    private def end_email_confirmation(user : Shield::User)
      EndEmailConfirmation.update!(
        email_confirmation,
        user_id: user.id,
        success: true,
        session: session
      )
    end

    private def end_email_confirmations(user : Shield::User)
      EmailConfirmationQuery.new
        .email(user.email)
        .is_active
        .update(inactive_at: Time.utc)
    end
  end
end
