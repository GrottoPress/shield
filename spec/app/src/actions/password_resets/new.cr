class PasswordResets::New < ApiAction
  include Shield::NewPasswordReset

  get "/password-resets/new" do
    json({status: 1})
  end
end
