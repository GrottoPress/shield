class Api::Users::OauthGrants::Destroy < ApiAction
  include Shield::Api::Users::OauthGrants::Destroy

  skip :pin_login_to_ip_address

  delete "/users/:user_id/oauth/grants" do
    run_operation
  end
end
