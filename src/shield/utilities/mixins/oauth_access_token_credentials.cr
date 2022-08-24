module Shield::OauthAccessTokenCredentials
  macro included
    getter? bearer_login : BearerLogin? do
      previous_def.try do |_bearer_login|
        BearerLoginQuery.preload_oauth_client(_bearer_login)
      end
    end
  end
end
