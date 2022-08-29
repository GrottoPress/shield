class Api::OauthGrants::Delete < ApiAction
  include Shield::Api::OauthGrants::Delete

  skip :pin_login_to_ip_address

  delete "/oauth/grants/:oauth_grant_id/delete" do
    run_operation
  end
end
