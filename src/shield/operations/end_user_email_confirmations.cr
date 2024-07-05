module Shield::EndUserEmailConfirmations # User::SaveOperation
  macro included
    after_save end_email_confirmations

    private def end_email_confirmations(user : Shield::User)
      EmailConfirmationQuery.new
        .user_id(user.id)
        .is_active
        .update(inactive_at: Time.utc)
    end
  end
end
