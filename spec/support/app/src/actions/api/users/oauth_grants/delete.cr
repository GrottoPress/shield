class Api::Users::OauthGrants::Delete < ApiAction
  include Shield::Api::Users::OauthGrants::Delete

  skip :pin_login_to_ip_address

  delete "/users/:user_id/oauth/grants/delete" do
    run_operation
  end
end
