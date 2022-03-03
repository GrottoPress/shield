class EmailConfirmations::Show < BrowserAction
  include Shield::EmailConfirmations::Show

  get "/email-confirmations/:token" do
    run_operation
  end
end
