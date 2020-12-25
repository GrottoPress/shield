require "../../../../spec_helper"

describe Shield::Api::CurrentUser::Create do
  it "creates user" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    response = ApiClient.exec(Api::CurrentUser::Create, user: {
      email: email,
      password: password,
      password_notify: true,
      login_notify: true,
    })

    response.should send_json(200, {status: "success"})
  end

  it "requires logged out" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.api_auth(email, password)

    response = client.exec(Api::CurrentUser::Create, user: {
      email: "john@example.com",
      password: password
    })

    response.should send_json(200, logged_in: true)
  end
end
