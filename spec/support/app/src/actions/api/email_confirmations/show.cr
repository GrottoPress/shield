class Api::EmailConfirmations::Show < ApiAction
  include Shield::Api::EmailConfirmations::Show

  skip :pin_login_to_ip_address

  get "/email-confirmations/:token" do
    json({
      status: "success",
      data: {email_confirmation: EmailConfirmationSerializer.new(
        email_confirmation
      )}
    })
  end
end
