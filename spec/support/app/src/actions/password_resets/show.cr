class PasswordResets::Show < BrowserAction
  include Shield::PasswordResets::Show

  param token : String

  get "/password-resets" do
    run_operation
  end
end
