require "../../../../spec_helper"

describe Shield::Api::CurrentLogin::Destroy do
  it "logs user out" do
    email = "user@example.tld"
    password = "password4APASSWORD<"
    ip_address = Socket::IPAddress.new("128.0.0.2", 5000)

    client = ApiClient.new
    client.api_auth(email, password, ip_address)

    response = client.exec(Api::CurrentLogin::Destroy)

    response.should send_json(200, {
      message: "action.current_login.destroy.success"
    })
  end

  it "requires logged in" do
    response = ApiClient.exec(Api::CurrentLogin::Destroy)

    response.should send_json(401, logged_in: false)
  end
end
