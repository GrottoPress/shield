class Api::CurrentUser::OauthPermissions::Index < ApiAction
  include Shield::Api::CurrentUser::OauthPermissions::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/account/oauth/permissions" do
    json OauthClientSerializer.new(oauth_clients: oauth_clients, pages: pages)
  end
end
