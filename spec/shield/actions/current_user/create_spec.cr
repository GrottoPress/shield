require "../../../spec_helper"

describe Shield::CurrentUser::Create do
  it "creates user" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    response = ApiClient.exec(CurrentUser::Create, user: {
      email: email,
      password: password,
      password_notify: true,
      login_notify: true,
    })

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-User-ID"]?.should eq("current_user_id")
  end

  it "requires logged out" do
    email = "user@example.tld"
    password = "password4APASSWORD<"
    ip_address = Socket::IPAddress.new("128.0.0.2", 5000)

    client = ApiClient.new
    client.browser_auth(email, password, ip_address)

    response = client.exec(CurrentUser::Create, user: {
      email: email,
      password: password,
      password_notify: true,
      login_notify: true
    })

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("true")
  end
end
