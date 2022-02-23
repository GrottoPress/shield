class Api::Users::BearerLogins::Index < ApiAction
  include Shield::Api::Users::BearerLogins::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/users/:user_id/bearer-logins" do
    json({
      status: "success",
      data: {
        bearer_logins: BearerLoginSerializer.for_collection(bearer_logins)
      },
      pages: {
        current: page,
        total: pages.total
      }
    })
  end
end
