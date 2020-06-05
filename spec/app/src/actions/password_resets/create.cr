class PasswordResets::Create < ApiAction
  include Shield::CreatePasswordReset

  post "/password-resets" do
    save_password_reset
  end
end
