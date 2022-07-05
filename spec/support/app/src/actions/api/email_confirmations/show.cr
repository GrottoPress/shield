class Api::EmailConfirmations::Show < ApiAction
  include Shield::Api::EmailConfirmations::Show

  skip :pin_login_to_ip_address

  get "/email-confirmations/:email_confirmation_id" do
    json EmailConfirmationSerializer.new(email_confirmation: email_confirmation)
  end
end
