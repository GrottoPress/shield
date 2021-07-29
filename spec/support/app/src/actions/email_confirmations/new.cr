class EmailConfirmations::New < BrowserAction
  include Shield::EmailConfirmations::New

  get "/email-confirmations/new" do
    operation = StartEmailConfirmation.new(remote_ip: remote_ip?)
    html NewPage, operation: operation
  end
end
