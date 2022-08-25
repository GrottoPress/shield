require "../../../../spec_helper"

describe Shield::Api::Users::Create do
  it "creates user" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.api_auth(email, password)

    response = client.exec(
      Api::Users::Create,
      user: {
        email: "who@some.one",
        password: password,
        level: User::Level.new(:author).to_s
      },
      user_options: {
        password_notify: true,
        login_notify: true,
        bearer_login_notify: true,
        oauth_access_token_notify: true
      }
    )

    response.should send_json(200, {message: "action.user.create.success"})
  end

  it "requires logged in" do
    response = ApiClient.exec(
      Api::Users::Create,
      user: {
        email: "user@example.tld",
        password: "password4APASSWORD<",
        level: User::Level.new(:author).to_s
      },
      user_options: {
        password_notify: true,
        login_notify: true,
        bearer_login_notify: true,
        oauth_access_token_notify: true
      }
    )

    response.should send_json(401, logged_in: false)
  end
end
