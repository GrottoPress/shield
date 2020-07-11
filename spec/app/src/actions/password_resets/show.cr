class PasswordResets::Show < ApiAction
  include Shield::ShowPasswordReset

  param id : Int64
  param token : String

  get "/password-resets" do
    verify_token
  end
end
