require "../../../spec_helper"

describe Shield::CurrentUser::Show do
  it "renders show page" do
    email = "user@example.tld"
    password = "password4APASSWORD<"
    ip_address = Socket::IPAddress.new("128.0.0.2", 5000)

    client = ApiClient.new
    client.browser_auth(email, password, ip_address)

    response = client.exec(RegularCurrentUser::Show)

    response.body.should eq("RegularCurrentUser::ShowPage")
  end

  it "requires logged in" do
    response = ApiClient.exec(RegularCurrentUser::Show)

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
