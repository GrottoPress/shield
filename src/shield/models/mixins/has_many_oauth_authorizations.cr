module Shield::HasManyOauthAuthorizations
  macro included
    has_many oauth_authorizations : OauthAuthorization
  end
end
