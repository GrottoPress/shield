class PasswordResets::Index < ApiAction
  include Shield::IndexPasswordReset

  param id : Int64
  param token : String

  get "/password-resets" do
    verify_token
  end
end
