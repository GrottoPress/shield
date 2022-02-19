class CurrentLogins::Index < BrowserAction
  include Shield::CurrentLogins::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/account/logins" do
    html IndexPage, logins: logins, pages: pages
  end
end
