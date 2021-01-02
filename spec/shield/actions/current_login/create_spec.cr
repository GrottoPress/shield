require "../../../spec_helper"

describe Shield::CurrentLogin::Create do
  it "logs user in" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    user = UserBox.create &.email(email)
      .password_digest(BcryptHash.new(password).hash)

    client = ApiClient.new

    response = client.exec(CurrentLogin::Create, login: {
      email: email,
      password: password
    })

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-User-ID"]?.should eq(user.id.to_s)
  end

  it "requires logged out" do
    email = "user@example.tld"
    password = "password4APASSWORD<"
    ip_address = Socket::IPAddress.new("128.0.0.2", 5000)

    client = ApiClient.new
    client.browser_auth(email, password, ip_address)

    response = client.exec(CurrentLogin::Create, login: {
      email: email,
      password: password
    })

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("true")
  end
end
