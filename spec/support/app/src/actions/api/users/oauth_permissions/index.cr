class Api::Users::OauthPermissions::Index < ApiAction
  include Shield::Api::Users::OauthPermissions::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/users/:user_id/oauth/permissions" do
    json OauthClientSerializer.new(
      oauth_clients: oauth_clients,
      user: user,
      pages: pages
    )
  end
end
