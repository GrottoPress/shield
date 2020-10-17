class EmailConfirmations::Show < BrowserAction
  include Shield::EmailConfirmations::Show

  param token : String

  get "/email-confirmations" do
    run_operation
  end
end
