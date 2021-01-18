require "../../../spec_helper"

describe Shield::Users::Show do
  it "renders edit page" do
    email = "user@example.tld"
    password = "password4APASSWORD<"
    ip_address = Socket::IPAddress.new("128.0.0.2", 5000)

    user = UserBox.create
    UserOptionsBox.create &.user_id(user.id)

    client = ApiClient.new
    client.browser_auth(email, password, ip_address)

    response = client.exec(Users::Show.with(user_id: user.id))

    response.body.should eq("Users::ShowPage")
  end

  it "requires logged in" do
    user = UserBox.create
    UserOptionsBox.create &.user_id(user.id)

    response = ApiClient.exec(Users::Show.with(user_id: user.id))

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
