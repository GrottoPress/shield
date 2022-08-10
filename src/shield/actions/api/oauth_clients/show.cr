module Shield::Api::OauthClients::Show
  macro included
    skip :require_logged_out

    # get "/oauth/clients/:oauth_client_id" do
    #   json OauthClientSerializer.new(oauth_client: oauth_client)
    # end

    getter oauth_client : OauthClient do
      OauthClientQuery.find(oauth_client_id)
    end

    def authorize?(user : Shield::User) : Bool
      super || user.id == oauth_client.user_id
    end
  end
end
