class PasswordResets::Show < BrowserAction
  include Shield::PasswordResets::Show

  get "/password-resets/:token" do
    run_operation
  end
end
