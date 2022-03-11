class Api::CurrentUser::BearerLogins::Index < ApiAction
  include Shield::Api::CurrentUser::BearerLogins::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/account/bearer-logins" do
    json ListResponse.new(bearer_logins: bearer_logins, pages: pages)
  end
end
