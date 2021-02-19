require "../../../spec_helper"

describe Shield::Users::Create do
  it "creates user" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.browser_auth(email, password)

    response = client.exec(
      Users::Create,
      user: {
        email: "who@some.one",
        password: password,
        level: User::Level.new(:author).to_s
      },
      user_options: {
        password_notify: true,
        login_notify: true,
        bearer_login_notify: true
      }
    )

    response.headers["X-User-ID"]?.should eq("user_id")
  end

  it "requires logged in" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    response = ApiClient.exec(
      Users::Create,
      user: {
        email: email,
        password: password,
        level: User::Level.new(:author).to_s
      },
      user_options: {
        password_notify: true,
        login_notify: true,
        bearer_login_notify: true
      }
    )

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
