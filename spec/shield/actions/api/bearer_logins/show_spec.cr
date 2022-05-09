require "../../../../spec_helper"

describe Shield::Api::BearerLogins::Show do
  it "shows bearer login" do
    password = "password4APASSWORD<"

    user = UserFactory.create &.password(password)
    bearer_login = BearerLoginFactory.create &.user_id(user.id)
    UserOptionsFactory.create &.user_id(user.id)

    client = ApiClient.new
    client.api_auth(user, password)

    response = client.exec(Api::BearerLogins::Show.with(
      bearer_login_id: bearer_login.id
    ))

    response.should send_json(200, {status: "success"})
  end

  it "requires logged in" do
    response = ApiClient.exec(Api::BearerLogins::Show.with(bearer_login_id: 5))

    response.should send_json(401, logged_in: false)
  end
end
