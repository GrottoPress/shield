class CurrentUser::Update < BrowserAction
  include Shield::EmailConfirmationCurrentUser::Update

  skip :pin_login_to_ip_address

  patch "/ec/profile" do
    run_operation
  end
end
