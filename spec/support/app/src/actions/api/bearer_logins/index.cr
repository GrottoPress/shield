class Api::BearerLogins::Index < ApiAction
  include Shield::Api::BearerLogins::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/bearer-logins" do
    json({
      status: "success",
      data: {
        bearer_logins: BearerLoginSerializer.for_collection(
          active_bearer_logins
        )
      },
      pages: {
        current: page,
        total: pages.total
      }
    })
  end

  private def active_bearer_logins
    bearer_logins.select &.active?
  end
end
