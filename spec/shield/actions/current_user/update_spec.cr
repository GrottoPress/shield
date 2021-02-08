require "../../../spec_helper"

describe Shield::CurrentUser::Update do
  it "updates user" do
    email = "user@example.tld"
    new_email = "newuser@domain.com.gh"
    password = "password4APASSWORD<"
    ip_address = Socket::IPAddress.new("128.0.0.2", 5000)

    user = UserFactory.create &.email(email).password(password)
    UserOptionsFactory.create &.user_id(user.id)

    client = ApiClient.new
    client.browser_auth(user, password, ip_address)

    response = client.exec(
      RegularCurrentUser::Update,
      user: {email: new_email},
      user_options: {login_notify: true}
    )

    response.headers["X-User-ID"]?.should eq(user.id.to_s)
  end

  it "requires logged in" do
    response = ApiClient.exec(
      RegularCurrentUser::Update,
      user: {email: "user@email.com"},
      user_options: {login_notify: true}
    )

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
