class PasswordResets::Edit < ApiAction
  include Shield::EditPasswordReset

  get "/password-resets/edit" do
    verify_password_reset
  end
end
