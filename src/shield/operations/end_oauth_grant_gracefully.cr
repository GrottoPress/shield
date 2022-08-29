module Shield::EndOauthGrantGracefully
  macro included
    after_save end_oauth_grant

    private def end_oauth_grant(oauth_grant : OauthGrant)
      inactive_time = oauth_grant.type.refresh_token? ?
        Time.utc + Shield.settings.oauth_refresh_token_grace :
        Time.utc

      self.record = EndOauthGrant.update!(
        oauth_grant,
        inactive_at: inactive_time
      )
    end
  end
end
