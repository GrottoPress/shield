class Api::CurrentUser::BearerLogins::Index < ApiAction
  include Shield::Api::CurrentUser::BearerLogins::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/account/bearer-logins" do
    json({
      status: "success",
      data: {
        bearer_logins: BearerLoginSerializer.for_collection(bearer_logins)
      },
      pages: PaginationSerializer.new(pages)
    })
  end
end
