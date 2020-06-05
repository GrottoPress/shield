class PasswordResets::Update < ApiAction
  include Shield::UpdatePasswordReset

  patch "/password-resets" do
    reset_password
  end
end
