class EmailConfirmations::Token::Show < BrowserAction
  include Shield::EmailConfirmations::Token::Show

  get "/email-confirmations/token/:token" do
    run_operation
  end
end
