class EmailConfirmations::New < BrowserAction
  include Shield::EmailConfirmations::New

  get "/email-confirmations/new" do
    plain_text "EmailConfirmations::New"
  end
end
