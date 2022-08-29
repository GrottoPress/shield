class Api::CurrentUser::OauthGrants::Delete < ApiAction
  include Shield::Api::CurrentUser::OauthGrants::Delete

  skip :pin_login_to_ip_address

  delete "/account/oauth/grants/delete" do
    run_operation
  end
end
