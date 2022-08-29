module Shield::HasManyOauthGrants
  macro included
    has_many oauth_grants : OauthGrant
  end
end
