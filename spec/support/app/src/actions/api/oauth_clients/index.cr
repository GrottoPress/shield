class Api::OauthClients::Index < ApiAction
  include Shield::Api::OauthClients::Index

  skip :check_authorization
  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/oauth/clients" do
    json OauthClientSerializer.new(oauth_clients: oauth_clients, pages: pages)
  end
end
