class Api::OauthAccessTokens::Index < ApiAction
  include Shield::Api::OauthAccessTokens::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/oauth/tokens" do
    json BearerLoginSerializer.new(bearer_logins: bearer_logins, pages: pages)
  end
end
