require "../../../../../spec_helper"

describe Shield::Api::Users::OauthGrants::Destroy do
  it "deactivates OAuth grants" do
    password = "password4APASSWORD<"

    user = UserFactory.create &.email("nobody@domain.com")
    UserOptionsFactory.create &.user_id(user.id)

    admin = UserFactory.create &.level(:admin).password(password)
    UserOptionsFactory.create &.user_id(admin.id)

    client = ApiClient.new
    client.api_auth(admin, password)

    response = client.exec(Api::Users::OauthGrants::Destroy.with(
      user_id: user.id
    ))

    response.should send_json(200, {
      message: "action.user.oauth_grant.destroy.success"
    })
  end

  it "requires logged in" do
    response = ApiClient.exec(Api::Users::OauthGrants::Destroy.with(
      user_id: 6
    ))

    response.should send_json(401, logged_in: false)
  end
end
