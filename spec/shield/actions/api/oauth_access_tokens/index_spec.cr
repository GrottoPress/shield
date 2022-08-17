require "../../../../spec_helper"

describe Shield::Api::OauthAccessTokens::Index do
  it "lists OAuth access tokens" do
    password = "password4APASSWORD<"

    user = UserFactory.create &.password(password).level(:admin)
    UserOptionsFactory.create &.user_id(user.id)

    client = ApiClient.new
    client.api_auth(user, password)

    response = client.exec(Api::OauthAccessTokens::Index)

    response.should send_json(200, {status: "success"})
  end

  it "requires logged in" do
    response = ApiClient.exec(Api::OauthAccessTokens::Index)

    response.should send_json(401, logged_in: false)
  end
end
