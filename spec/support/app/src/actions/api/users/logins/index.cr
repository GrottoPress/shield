class Api::Users::Logins::Index < ApiAction
  include Shield::Api::Users::Logins::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/users/:user_id/logins" do
    json({
      status: "success",
      data: {logins: LoginSerializer.for_collection(logins)},
      pages: {
        current: page,
        total: pages.total
      }
    })
  end
end
