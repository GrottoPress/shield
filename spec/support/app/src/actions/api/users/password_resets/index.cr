class Api::Users::PasswordResets::Index < ApiAction
  include Shield::Api::Users::PasswordResets::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/users/:user_id/password-resets" do
    json({
      status: "success",
      data: {
        password_resets: PasswordResetSerializer.for_collection(password_resets)
      },
      pages: PaginationSerializer.new(pages)
    })
  end
end
