module Shield::NotifyPasswordChange
  macro included
    after_completed notify_password_change

    private def notify_password_change(user : User)
      return unless password_digest.changed?
      return unless user.options!.password_notify

      mail_later PasswordChangeNotificationEmail, self, user
    end
  end
end
