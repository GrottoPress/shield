require "../../../../spec_helper"

describe Shield::Api::BearerLogins::Destroy do
  it "revokes bearer login" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    user = UserBox.create &.email(email)
      .password_digest(BcryptHash.new(password).hash)

    bearer_login = CreateBearerLogin.create!(
      params(name: "secret token"),
      scopes: ["api.posts.index"],
      allowed_scopes: ["api.posts.update", "api.posts.index"],
      user_id: user.id
    )

    client = ApiClient.new
    client.api_auth(user, password)

    response = client.exec(Api::BearerLogins::Destroy.with(
      bearer_login_id: bearer_login.id
    ))

    response.should send_json(200, {status: "success"})
    bearer_login.reload.inactive?.should be_true
  end

  it "requires logged in" do
    response = ApiClient.exec(Api::BearerLogins::Destroy.with(
      bearer_login_id: 1_i64
    ))

    response.should send_json(401, logged_in: false)
  end
end
