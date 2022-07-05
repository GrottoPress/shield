class PasswordResets::Show < BrowserAction
  include Shield::PasswordResets::Show

  skip :pin_login_to_ip_address

  get "/password-resets/:password_reset_id" do
    html ShowPage, password_reset: password_reset
  end
end
