class Api::EmailConfirmations::Index < ApiAction
  include Shield::Api::EmailConfirmations::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/email-confirmations" do
    json({
      status: "success",
      data: {email_confirmations: EmailConfirmationSerializer.for_collection(
        email_confirmations
      )},
      pages: PaginationSerializer.new(pages)
    })
  end
end
