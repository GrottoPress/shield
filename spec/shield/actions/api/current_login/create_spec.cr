require "../../../../spec_helper"

describe Shield::Api::CurrentLogin::Create do
  it "logs user in" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    user = UserFactory.create &.email(email).password(password)
    UserOptionsFactory.create &.user_id(user.id)

    client = ApiClient.new

    response = client.exec(Api::CurrentLogin::Create, login: {
      email: email,
      password: password
    })

    response.should send_json(
      200,
      {message: "action.current_login.create.success"}
    )
  end

  it "requires logged out" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.api_auth(email, password)

    response = client.exec(Api::CurrentLogin::Create, login: {
      email: email,
      password: password
    })

    response.should send_json(200, logged_in: true)
  end
end
