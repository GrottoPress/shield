class Api::LoginsEverywhere::Index < ApiAction
  include Shield::Api::LoginsEverywhere::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/login/all" do
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
