module Shield::OauthAccessTokenVerifier
  macro included
    def verify!(oauth_client : OauthClient, scope : String? = nil)
      verify(oauth_client, scope).not_nil!
    end

    def verify(oauth_client : OauthClient, scope : String? = nil)
      yield self, verify(oauth_client, scope)
    end

    def verify(oauth_client : OauthClient, scope : String? = nil) : BearerLogin?
      bearer_login? if verify?(oauth_client, scope)
    end

    def verify?(oauth_client : OauthClient, scope : String? = nil) : Bool?
      verify?(scope) && bearer_login.oauth_client_id == oauth_client.id
    end
  end
end
