class PasswordResets::Show < ApiAction
  include Shield::PasswordResets::Show

  param id : Int64
  param token : String

  get "/password-resets" do
    run_operation
  end
end
