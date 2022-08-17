class Api::Users::OauthAccessTokens::Index < ApiAction
  include Shield::Api::Users::OauthAccessTokens::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/users/:user_id/oauth/tokens" do
    json BearerLoginSerializer.new(
      bearer_logins: bearer_logins,
      user: user,
      pages: pages
    )
  end
end
