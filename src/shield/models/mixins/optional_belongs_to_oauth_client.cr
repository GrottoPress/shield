module Shield::OptionalBelongsToOauthClient
  macro included
    belongs_to oauth_client : OauthClient?
  end
end
