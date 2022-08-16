class Api::OauthAuthorizations::Show < ApiAction
  include Shield::Api::OauthAuthorizations::Show

  skip :check_authorization
  skip :pin_login_to_ip_address

  get "/oauth/authorizations/:oauth_authorization_id" do
    json OauthAuthorizationSerializer.new(
      oauth_authorization: oauth_authorization
    )
  end
end
