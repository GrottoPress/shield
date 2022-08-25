module Shield::NotifyOauthAccessToken
  macro included
    after_commit notify_bearer_login

    private def notify_bearer_login(bearer_login : Shield::BearerLogin)
      bearer_login = BearerLoginQuery.preload_user(
        bearer_login,
        UserQuery.new.preload_options
      )

      bearer_login = BearerLoginQuery.preload_oauth_client(bearer_login)

      return unless bearer_login.user.options.oauth_access_token_notify

      mail_later OauthAccessTokenNotificationEmail, self, bearer_login
    end
  end
end
