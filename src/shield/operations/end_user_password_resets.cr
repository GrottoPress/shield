module Shield::EndUserPasswordResets # User::SaveOperation
  macro included
    after_save end_password_resets

    private def end_password_resets(user : Shield::User)
      PasswordResetQuery.new
        .user_id(user.id)
        .is_active
        .update(inactive_at: Time.utc)
    end
  end
end
