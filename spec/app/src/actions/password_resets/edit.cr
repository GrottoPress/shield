class PasswordResets::Edit < ApiAction
  include Shield::EditPasswordReset

  get "/password-resets/edit" do
    edit_password_reset
  end
end
