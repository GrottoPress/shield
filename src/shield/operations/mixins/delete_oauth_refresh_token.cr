module Shield::DeleteOauthRefreshToken
  macro included
    include Shield::RevokeOauthRefreshToken

    private def revoke_refresh_token_permission
      @oauth_grant.try do |oauth_grant|
        DeleteOauthPermission.update!(
          oauth_grant.oauth_client,
          user: oauth_grant.user
        )
      end

      token.value.not_nil!
    end
  end
end
