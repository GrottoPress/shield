module Shield::ResetPassword
  macro included
    attribute password : String

    before_save do
      validate_required password
    end

    after_save end_password_resets

    after_completed do |saved_record|
      end_password_resets(saved_record) if changes.empty?
    end

    include Shield::UpdatePassword
    include Shield::DeleteSession

    private def end_password_resets(user : User)
      PasswordResetQuery.new
        .user_id(user.id)
        .is_active
        .update(ended_at: Time.utc)
    end

    private def delete_session(user : User)
      session.try { |session| PasswordResetSession.new(session).delete }
    end
  end
end
