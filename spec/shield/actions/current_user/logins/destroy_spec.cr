require "../../../../spec_helper"

describe Shield::CurrentUser::Logins::Destroy do
  it "logs user out everywhere" do
    email = "user@example.tld"
    password = "password4APASSWORD<"
    ip_address = Socket::IPAddress.new("128.0.0.2", 5000)

    client = ApiClient.new
    client.browser_auth(email, password, ip_address)

    response = client.exec(CurrentUser::Logins::Destroy)

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Log-Out-Everywhere"]?.should eq("true")
  end

  it "requires logged in" do
    response = ApiClient.exec(CurrentUser::Logins::Destroy)

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
