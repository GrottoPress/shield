class Users::PasswordResets::Index < BrowserAction
  include Shield::Users::PasswordResets::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/users/:user_id/password-resets" do
    html IndexPage, password_resets: password_resets, user: user, pages: pages
  end
end
