module Shield::EndOauthAuthorizationGracefully
  macro included
    needs oauth_grant_type : OauthGrantType

    after_save end_oauth_authorization

    private def end_oauth_authorization(
      oauth_authorization : OauthAuthorization
    )
      inactive_time = oauth_grant_type.refresh_token? ?
        Time.utc + Shield.settings.oauth_refresh_token_grace :
        Time.utc

      self.record = EndOauthAuthorization.update!(
        oauth_authorization,
        inactive_at: inactive_time
      )
    end
  end
end
