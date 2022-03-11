class Api::Users::PasswordResets::Index < ApiAction
  include Shield::Api::Users::PasswordResets::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/users/:user_id/password-resets" do
    json ListResponse.new(
      password_resets: password_resets,
      user: user,
      pages: pages
    )
  end
end
