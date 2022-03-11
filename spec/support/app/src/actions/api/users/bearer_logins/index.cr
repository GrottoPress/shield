class Api::Users::BearerLogins::Index < ApiAction
  include Shield::Api::Users::BearerLogins::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/users/:user_id/bearer-logins" do
    json ListResponse.new(
      bearer_logins: bearer_logins,
      user: user,
      pages: pages
    )
  end
end
