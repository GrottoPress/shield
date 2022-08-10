class Api::OauthClients::Show < ApiAction
  include Shield::Api::OauthClients::Show

  skip :check_authorization
  skip :pin_login_to_ip_address

  get "/oauth/clients/:oauth_client_id" do
    json OauthClientSerializer.new(oauth_client: oauth_client)
  end
end
