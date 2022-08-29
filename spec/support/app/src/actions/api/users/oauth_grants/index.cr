class Api::Users::OauthGrants::Index < ApiAction
  include Shield::Api::Users::OauthGrants::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/users/:user_id/oauth/grants" do
    json OauthGrantSerializer.new(
      oauth_grants: oauth_grants,
      user: user,
      pages: pages
    )
  end
end
