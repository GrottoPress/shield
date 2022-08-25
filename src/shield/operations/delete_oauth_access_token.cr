module Shield::DeleteOauthAccessToken
  macro included
    include Shield::RevokeOauthAccessToken

    private def revoke_oauth_permission
      @bearer_login.try do |bearer_login|
        bearer_login.oauth_client.try do |client|
          DeleteOauthPermission.update!(bearer_login.user!, client)
        end

        token.value.not_nil!
      end
    end
  end
end
