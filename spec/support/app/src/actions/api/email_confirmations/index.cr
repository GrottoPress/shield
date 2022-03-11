class Api::EmailConfirmations::Index < ApiAction
  include Shield::Api::EmailConfirmations::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/email-confirmations" do
    json ListResponse.new(
      email_confirmations: email_confirmations,
      pages: pages
    )
  end
end
