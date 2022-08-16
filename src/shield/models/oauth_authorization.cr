module Shield::OauthAuthorization
  macro included
    include Shield::BelongsToOauthClient
    include Shield::BelongsToUser # Resource owner
    include Lucille::SuccessStatusColumns

    column code_digest : String
    column pkce : OauthAuthorizationPkce?, serialize: true
    column scopes : Array(String)
  end
end
