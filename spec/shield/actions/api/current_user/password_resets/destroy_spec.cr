require "../../../../../spec_helper"

describe Shield::Api::CurrentUser::PasswordResets::Destroy do
  it "ends password resets" do
    email = "user@example.tld"
    password = "password4APASSWORD<"
    ip_address = Socket::IPAddress.new("128.0.0.2", 5000)

    client = ApiClient.new
    client.api_auth(email, password, ip_address)

    response = client.exec(Api::CurrentUser::PasswordResets::Destroy)

    response.should send_json(200, {
      message: "action.current_user.password_reset.destroy.success"
    })
  end

  it "requires logged in" do
    response = ApiClient.exec(Api::CurrentUser::PasswordResets::Destroy)

    response.should send_json(401, logged_in: false)
  end
end
