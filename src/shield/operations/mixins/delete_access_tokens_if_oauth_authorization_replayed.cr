module Shield::DeleteAccessTokensIfOauthAuthorizationReplayed
  macro included
    private def revoke_access_tokens
      oauth_authorization.try do |authorization|
        return if authorization.status.active?

        BearerLoginQuery.new
          .user_id(authorization.user_id)
          .oauth_client_id(authorization.oauth_client_id)
          .delete
      end
    end
  end
end
