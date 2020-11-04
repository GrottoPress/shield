class PasswordResets::Create < BrowserAction
  include Shield::PasswordResets::Create

  post "/password-resets" do
    run_operation
  end
end
