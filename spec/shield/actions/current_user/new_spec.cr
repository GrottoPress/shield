require "../../../spec_helper"

describe Shield::CurrentUser::New do
  it "renders new page" do
    response = ApiClient.exec(CurrentUser::New)

    response.body.should eq("CurrentUser::NewPage")
  end

  it "requires logged out" do
    email = "user@example.tld"
    password = "password4APASSWORD<"
    ip_address = Socket::IPAddress.new("128.0.0.2", 5000)

    client = ApiClient.new
    client.browser_auth(email, password, ip_address)

    response = client.exec(CurrentUser::New)

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("true")
  end
end
