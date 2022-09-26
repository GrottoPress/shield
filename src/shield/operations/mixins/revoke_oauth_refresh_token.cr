module Shield::RevokeOauthRefreshToken
  macro included
    @oauth_grant : OauthGrant?

    before_run do
      set_oauth_grant

      validate_grant_is_refresh_token
      validate_refresh_token_client_authorized
    end

    private def revoke_oauth_permission
      @bearer_login ? previous_def : revoke_refresh_token_permission
    end

    private def set_oauth_grant
      return if @bearer_login

      token.value.try do |value|
        @oauth_grant = OauthGrantCredentials.from_token?(value)
          .try(&.oauth_grant?)
      end
    end

    private def validate_grant_is_refresh_token
      @oauth_grant.try do |oauth_grant|
        return if oauth_grant.type.refresh_token?
        token.add_error Rex.t(:"operation.error.oauth_grant_type_invalid")
      end
    end

    private def validate_refresh_token_client_authorized
      @oauth_grant.try do |oauth_grant|
        return if oauth_client.id == oauth_grant.oauth_client_id

        @client_authorized = false
        token.add_error Rex.t(:"operation.error.oauth_client_not_authorized")
      end
    end

    private def revoke_refresh_token_permission
      @oauth_grant.try do |oauth_grant|
        RevokeOauthPermission.update!(
          oauth_grant.oauth_client,
          user: oauth_grant.user
        )
      end

      token.value.not_nil!
    end
  end
end
