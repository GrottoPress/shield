class EmailConfirmations::Create < BrowserAction
  include Shield::EmailConfirmations::Create

  post "/email-confirmations" do
    run_operation
  end
end
