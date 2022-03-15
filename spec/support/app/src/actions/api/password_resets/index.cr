class Api::PasswordResets::Index < ApiAction
  include Shield::Api::PasswordResets::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/password-resets" do
    json PasswordResetSerializer.new(
      password_resets: password_resets,
      pages: pages
    )
  end
end
