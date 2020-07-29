
module Shield::UpdatePassword
  macro included
    include Shield::ValidatePassword
    include Shield::SetPasswordHash

    needs current_login : Login?

    after_save log_out_everywhere

    after_commit notify_password_change

    private def log_out_everywhere(user : User)
      return unless password_hash.changed?

      LoginQuery.new
        .status(Login::Status.new :started)
        .id.not.eq(current_login.try(&.id) || 0_i64)
        .update(ended_at: Time.utc, status: Login::Status.new(:ended))
    end

    private def notify_password_change(user : User)
      return unless password_hash.changed?
      return unless user.options!.password_notify

      mail_later PasswordChangeNotificationEmail, self, user
    end
  end
end
