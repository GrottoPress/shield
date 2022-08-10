class Api::CurrentUser::OauthClients::Destroy < ApiAction
  include Shield::Api::CurrentUser::OauthClients::Destroy

  skip :pin_login_to_ip_address

  delete "/account/oauth/clients" do
    run_operation
  end
end
