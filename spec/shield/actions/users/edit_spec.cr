require "../../../spec_helper"

describe Shield::Users::Edit do
  it "renders edit page" do
    email = "user@example.tld"
    password = "password4APASSWORD<"
    ip_address = Socket::IPAddress.new("129.0.0.5", 6000)

    user = UserFactory.create
    UserOptionsFactory.create &.user_id(user.id)

    client = ApiClient.new
    client.browser_auth(email, password, ip_address)

    response = client.exec(Users::Edit.with(user_id: user.id))

    response.body.should eq("Users::EditPage")
  end

  it "requires logged in" do
    user = UserFactory.create
    UserOptionsFactory.create &.user_id(user.id)

    response = ApiClient.exec(Users::Edit.with(user_id: user.id))

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
