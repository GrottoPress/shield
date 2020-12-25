require "../../../spec_helper"

describe Shield::CurrentLogin::Destroy do
  it "logs user out" do
    email = "user@example.tld"
    password = "password4APASSWORD<"
    ip_address = Socket::IPAddress.new("128.0.0.2", 5000)

    client = ApiClient.new
    client.browser_auth(email, password, ip_address)

    response = client.exec(CurrentLogin::Destroy)

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Current-Login"]?.should eq("0")
  end

  it "requires logged in" do
    response = ApiClient.exec(CurrentLogin::Destroy)

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
