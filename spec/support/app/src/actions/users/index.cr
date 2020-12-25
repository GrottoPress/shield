class Users::Index < BrowserAction
  include Shield::Users::Index

  skip :pin_login_to_ip_address
  skip :check_authorization

  param page : Int32 = 1

  get "/users" do
    html IndexPage, users: users, pages: pages
  end
end
