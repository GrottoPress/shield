class EmailConfirmations::Index < BrowserAction
  include Shield::EmailConfirmations::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/email-confirmations" do
    html IndexPage, email_confirmations: email_confirmations, pages: pages
  end
end
