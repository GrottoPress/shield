require "../../../../../spec_helper"

describe Shield::Api::CurrentUser::Logins::Delete do
  it "logs user out everywhere" do
    email = "user@example.tld"
    password = "password4APASSWORD<"
    ip_address = Socket::IPAddress.new("128.0.0.2", 5000)

    client = ApiClient.new
    client.api_auth(email, password, ip_address)

    response = client.exec(Api::CurrentUser::Logins::Delete)

    response.should send_json(200, {
      message: "action.current_user.login.destroy.success"
    })
  end

  it "requires logged in" do
    response = ApiClient.exec(Api::CurrentUser::Logins::Delete)

    response.should send_json(401, logged_in: false)
  end
end
