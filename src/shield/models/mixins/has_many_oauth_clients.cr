module Shield::HasManyOauthClients
  macro included
    has_many oauth_clients : OauthClient
  end
end
