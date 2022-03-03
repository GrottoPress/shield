class Users::EmailConfirmations::Index < BrowserAction
  include Shield::Users::EmailConfirmations::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/users/:user_id/email-confirmations" do
    html IndexPage,
      email_confirmations: email_confirmations,
      user: user,
      pages: pages
  end
end
