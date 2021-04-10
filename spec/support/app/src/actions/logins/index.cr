class Logins::Index < BrowserAction
  include Shield::Logins::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/logins" do
    html IndexPage, logins: active_logins, pages: pages
  end

  private def active_logins
    logins.select &.active?
  end
end
