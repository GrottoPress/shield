class PasswordResets::Index < BrowserAction
  include Shield::PasswordResets::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/password-resets" do
    html IndexPage, password_resets: password_resets, pages: pages
  end
end
