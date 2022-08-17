class Api::CurrentUser::OauthAccessTokens::Index < ApiAction
  include Shield::Api::CurrentUser::OauthAccessTokens::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/account/oauth/tokens" do
    json BearerLoginSerializer.new(bearer_logins: bearer_logins, pages: pages)
  end
end
