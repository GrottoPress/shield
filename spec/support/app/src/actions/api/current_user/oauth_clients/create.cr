class Api::CurrentUser::OauthClients::Create < ApiAction
  include Shield::Api::CurrentUser::OauthClients::Create

  skip :pin_login_to_ip_address

  post "/account/oauth/clients" do
    run_operation
  end
end
