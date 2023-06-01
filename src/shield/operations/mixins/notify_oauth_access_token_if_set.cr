module Shield::NotifyOauthAccessTokenIfSet
  macro included
    after_commit notify_bearer_login

    private def notify_bearer_login(bearer_login : Shield::BearerLogin)
      bearer_login = BearerLoginQuery.preload_user(bearer_login)
      bearer_login = BearerLoginQuery.preload_oauth_client(bearer_login)

      return unless bearer_login.user.settings.oauth_access_token_notify?

      OauthAccessTokenNotificationEmail.new(self, bearer_login).deliver_later
    end
  end
end
