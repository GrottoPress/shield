module Shield::NotifyPasswordChangeIfSet
  macro included
    after_commit notify_password_change

    private def notify_password_change(user : Shield::User)
      return unless password_digest.changed?
      return unless user.settings.password_notify?

      mail_later PasswordChangeNotificationEmail, self, user
    end
  end
end
