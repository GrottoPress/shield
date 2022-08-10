class Api::CurrentUser::OauthClients::Index < ApiAction
  include Shield::Api::CurrentUser::OauthClients::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/account/oauth/clients" do
    json OauthClientSerializer.new(oauth_clients: oauth_clients, pages: pages)
  end
end
