class Api::CurrentUser::Create < ApiAction
  include Shield::Api::CurrentUser::Create

  skip :pin_login_to_ip_address

  post "/register" do
    run_operation
  end
end
