class Api::PasswordResets::Show < ApiAction
  include Shield::Api::PasswordResets::Show

  skip :pin_login_to_ip_address

  get "/password-resets/:password_reset_id" do
    json PasswordResetSerializer.new(password_reset: password_reset)
  end
end
