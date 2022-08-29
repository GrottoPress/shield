module Shield::DeleteAccessTokensIfOauthGrantReplayed
  macro included
    private def revoke_access_tokens
      oauth_grant.try do |grant|
        return if grant.status.active?

        BearerLoginQuery.new
          .user_id(grant.user_id)
          .oauth_client_id(grant.oauth_client_id)
          .delete
      end
    end
  end
end
