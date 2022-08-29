class Api::OauthGrants::Destroy < ApiAction
  include Shield::Api::OauthGrants::Destroy

  skip :pin_login_to_ip_address

  delete "/oauth/grants/:oauth_grant_id" do
    run_operation
  end
end
