module Shield::OauthClients::Secret::Show
  macro included
    skip :require_logged_out

    # get "/oauth/clients/secret" do
    #   html ShowPage, oauth_client: oauth_client?, secret: secret?
    # end

    def oauth_client : OauthClient
      oauth_client?.not_nil!
    end

    def oauth_client? : OauthClient?
      oauth_client_session[0]?
    end

    def secret : String
      secret?.not_nil!
    end

    def secret? : String?
      oauth_client_session[1]?
    end

    def authorize?(user : Shield::User) : Bool
      user.id == oauth_client?.try(&.user_id)
    end

    # This is to ensure we fetch `oauth_client` first before
    # `secret`, because fetching secret deletes the session
    private getter oauth_client_session : Tuple(OauthClient?, String?) do
      _session = OauthClientSession.new(session)
      {_session.oauth_client?, _session.oauth_client_secret?}
    end
  end
end
