require "../../../../spec_helper"

describe Shield::Api::EmailConfirmations::Index do
  it "renders index page" do
    password = "password4APASSWORD<"

    user = UserFactory.create &.password(password).level(:admin)
    UserOptionsFactory.create &.user_id(user.id)

    client = ApiClient.new
    client.api_auth(user, password)

    response = client.exec(Api::EmailConfirmations::Index)

    response.should send_json(200, {status: "success"})
  end

  it "requires logged in" do
    response = ApiClient.exec(Api::EmailConfirmations::Index)

    response.should send_json(401, logged_in: false)
  end
end
