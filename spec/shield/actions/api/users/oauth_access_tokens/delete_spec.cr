require "../../../../../spec_helper"

describe Shield::Api::Users::OauthAccessTokens::Delete do
  it "deletes OAuth access tokens" do
    password = "password4APASSWORD<"

    user = UserFactory.create &.email("nobody@domain.com")
    UserOptionsFactory.create &.user_id(user.id)

    admin = UserFactory.create &.level(:admin).password(password)
    UserOptionsFactory.create &.user_id(admin.id)

    client = ApiClient.new
    client.api_auth(admin, password)

    response = client.exec(Api::Users::OauthAccessTokens::Delete.with(
      user_id: user.id
    ))

    response.should send_json(200, {
      message: "action.user.bearer_login.destroy.success"
    })
  end

  it "requires logged in" do
    response = ApiClient.exec(Api::Users::OauthAccessTokens::Delete.with(
      user_id: 6
    ))

    response.should send_json(401, logged_in: false)
  end
end
