class Api::CurrentUser::OauthGrants::Destroy < ApiAction
  include Shield::Api::CurrentUser::OauthGrants::Destroy

  skip :pin_login_to_ip_address

  delete "/account/oauth/grants" do
    run_operation
  end
end
