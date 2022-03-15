class Api::CurrentUser::EmailConfirmations::Index < ApiAction
  include Shield::Api::CurrentUser::EmailConfirmations::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/account/email-confirmations" do
    json EmailConfirmationSerializer.new(
      email_confirmations: email_confirmations,
      pages: pages
    )
  end
end
