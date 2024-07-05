module Shield::DeleteOauthToken # Avram::Operation
  macro included
    include Shield::RevokeOauthToken

    private def revoke_oauth_permission
      @bearer_login.try do |bearer_login|
        bearer_login.oauth_client.try do |client|
          DeleteOauthPermission.update!(client, bearer_login.user)
        end
      end

      token.value.not_nil!
    end
  end
end
