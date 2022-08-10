class Api::CurrentUser::OauthClients::Delete < ApiAction
  include Shield::Api::CurrentUser::OauthClients::Delete

  skip :pin_login_to_ip_address

  delete "/account/oauth/clients/delete" do
    run_operation
  end
end
