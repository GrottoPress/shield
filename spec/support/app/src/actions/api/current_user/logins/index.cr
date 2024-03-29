class Api::CurrentUser::Logins::Index < ApiAction
  include Shield::Api::CurrentUser::Logins::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/account/logins" do
    json LoginSerializer.new(logins: logins, pages: pages)
  end
end
