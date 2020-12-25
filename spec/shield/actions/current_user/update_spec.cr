require "../../../spec_helper"

describe Shield::CurrentUser::Update do
  it "updates user" do
    email = "user@example.tld"
    new_email = "newuser@domain.com.gh"
    password = "password4APASSWORD<"
    ip_address = Socket::IPAddress.new("128.0.0.2", 5000)

    user = UserBox.create &.email(email)
      .password_digest(CryptoHelper.hash_bcrypt(password))

    client = ApiClient.new
    client.browser_auth(user, password, ip_address)

    response = client.exec(CurrentUser::Update, user: {email: new_email})

    response.headers["X-User-ID"]?.should eq(user.id.to_s)
  end

  it "requires logged in" do
    response = ApiClient.exec(CurrentUser::Update, user: {
      email: "user@email.com"
    })

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
