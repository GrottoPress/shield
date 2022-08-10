class Api::OauthClients::Users::Index < ApiAction
  include Shield::Api::OauthClients::Users::Index

  skip :check_authorization
  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/oauth/clients/:oauth_client_id/users" do
    json UserSerializer.new(
      users: users,
      oauth_client: oauth_client,
      pages: pages
    )
  end
end
