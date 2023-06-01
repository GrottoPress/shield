module Shield::NotifyLogin
  macro included
    after_commit notify_login

    private def notify_login(login : Shield::Login)
      login = LoginQuery.preload_user(login, UserQuery.new.preload_options)
      return unless login.user.options.login_notify

      LoginNotificationEmail.new(self, login).deliver_later
    end
  end
end
