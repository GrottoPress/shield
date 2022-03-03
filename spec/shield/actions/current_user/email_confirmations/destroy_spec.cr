require "../../../../spec_helper"

describe Shield::CurrentUser::EmailConfirmations::Destroy do
  it "ends email confirmations" do
    email = "user@example.tld"
    password = "password4APASSWORD<"
    ip_address = Socket::IPAddress.new("128.0.0.2", 5000)

    client = ApiClient.new
    client.browser_auth(email, password, ip_address)

    response = client.exec(CurrentUser::EmailConfirmations::Destroy)

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-End-Email-Confirmations"]?.should eq("true")
  end

  it "requires logged in" do
    response = ApiClient.exec(CurrentUser::EmailConfirmations::Destroy)

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
