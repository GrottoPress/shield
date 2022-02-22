class Users::Logins::Index < BrowserAction
  include Shield::Users::Logins::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/users/:user_id/logins" do
    html IndexPage, logins: logins, pages: pages
  end
end
