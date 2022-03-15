class Api::BearerLogins::Index < ApiAction
  include Shield::Api::BearerLogins::Index

  skip :check_authorization
  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/bearer-logins" do
    json BearerLoginSerializer.new(bearer_logins: bearer_logins, pages: pages)
  end
end
