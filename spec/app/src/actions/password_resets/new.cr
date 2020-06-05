class PasswordResets::New < ApiAction
  include Shield::NewPasswordReset

  get "/password-resets/new" do
    plain_text "PasswordResets::New"
  end
end
