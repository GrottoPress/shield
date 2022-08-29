class Api::OauthGrants::Show < ApiAction
  include Shield::Api::OauthGrants::Show

  skip :check_authorization
  skip :pin_login_to_ip_address

  get "/oauth/grants/:oauth_grant_id" do
    json OauthGrantSerializer.new(oauth_grant: oauth_grant)
  end
end
