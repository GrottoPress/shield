class Api::CurrentUser::Update < ApiAction
  include Shield::Api::CurrentUser::Update

  skip :pin_login_to_ip_address

  patch "/profile" do
    run_operation
  end
end
