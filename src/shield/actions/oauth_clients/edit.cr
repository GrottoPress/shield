module Shield::OauthClients::Edit
  macro included
    skip :require_logged_out

    authorize_user do |user|
      super || user.id == oauth_client.user_id
    end

    # get "/oauth/clients/:oauth_client_id/edit" do
    #   operation = UpdateOauthClient.new(oauth_client)
    #   html EditPage, operation: operation
    # end

    def oauth_client : OauthClient
      OauthClientQuery.find(oauth_client_id)
    end
  end
end
