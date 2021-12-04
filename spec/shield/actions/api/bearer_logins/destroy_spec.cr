require "../../../../spec_helper"

describe Shield::Api::BearerLogins::Destroy do
  it "revokes bearer login" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    user = UserFactory.create &.email(email).password(password)
    UserOptionsFactory.create &.user_id(user.id)
    bearer_login = BearerLoginFactory.create &.user_id(user.id)

    client = ApiClient.new
    client.api_auth(user, password)

    response = client.exec(Api::BearerLogins::Destroy.with(
      bearer_login_id: bearer_login.id
    ))

    response.should send_json(200, {
      message: "action.bearer_login.destroy.success"
    })

    bearer_login.reload.status.inactive?.should be_true
  end

  it "requires logged in" do
    response = ApiClient.exec(Api::BearerLogins::Destroy.with(
      bearer_login_id: 1_i64
    ))

    response.should send_json(401, logged_in: false)
  end
end
