module Shield::NotifyPasswordChange
  macro included
    after_commit notify_password_change

    private def notify_password_change(user : Shield::User)
      return unless password_digest.changed?

      user = UserQuery.preload_options(user)
      return unless user.options.password_notify

      PasswordChangeNotificationEmail.new(self, user).deliver_later
    end
  end
end
