class LoginsEverywhere::Index < BrowserAction
  include Shield::LoginsEverywhere::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/login/all" do
    html IndexPage, logins: logins, pages: pages
  end
end
