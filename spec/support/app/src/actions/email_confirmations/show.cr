class EmailConfirmations::Show < BrowserAction
  include Shield::EmailConfirmations::Show

  skip :pin_login_to_ip_address

  get "/email-confirmations/:email_confirmation_id" do
    html ShowPage, email_confirmation: email_confirmation
  end
end
