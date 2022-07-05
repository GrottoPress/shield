require "../../../../spec_helper"

describe Shield::Api::Logins::Show do
  it "shows  login" do
    password = "password4APASSWORD<"

    user = UserFactory.create &.password(password)
    login = LoginFactory.create &.user_id(user.id)
    UserOptionsFactory.create &.user_id(user.id)

    client = ApiClient.new
    client.api_auth(user, password)

    response = client.exec(Api::Logins::Show.with(
      login_id: login.id
    ))

    response.should send_json(200, {status: "success"})
  end

  it "requires logged in" do
    response = ApiClient.exec(Api::Logins::Show.with(login_id: 5))

    response.should send_json(401, logged_in: false)
  end
end
