class Api::Users::OauthAuthorizations::Index < ApiAction
  include Shield::Api::Users::OauthAuthorizations::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/users/:user_id/oauth/authorizations" do
    json OauthAuthorizationSerializer.new(
      oauth_authorizations: oauth_authorizations,
      user: user,
      pages: pages
    )
  end
end
