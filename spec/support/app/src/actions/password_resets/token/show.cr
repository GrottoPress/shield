class PasswordResets::Token::Show < BrowserAction
  include Shield::PasswordResets::Token::Show

  get "/password-resets/token/:token" do
    run_operation
  end
end
