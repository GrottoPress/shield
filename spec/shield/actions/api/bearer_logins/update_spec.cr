require "../../../../spec_helper"

describe Shield::Api::BearerLogins::Update do
  it "updates bearer login" do
    password = "password4APASSWORD<"
    new_name = "new secret"
    new_scopes = ["api.current_user.show"]

    user = UserFactory.create &.password(password)
    UserOptionsFactory.create &.user_id(user.id)

    bearer_login = BearerLoginFactory.create &.user_id(user.id)
      .name("secret")
      .scopes(["posts.update"])

    client = ApiClient.new
    client.api_auth(user, password)

    response = client.exec(
      Api::BearerLogins::Update.with(bearer_login_id: bearer_login.id),
      bearer_login: {name: new_name, scopes: new_scopes}
    )

    response.should send_json(
      200,
      {message: "action.bearer_login.update.success"}
    )

    bearer_login.reload.tap do |updated_bearer_login|
      updated_bearer_login.name.should eq(new_name)
      updated_bearer_login.scopes.should eq(new_scopes)
    end
  end

  it "requires logged in" do
    response = ApiClient.exec(
      Api::BearerLogins::Update.with(bearer_login_id: 22),
      bearer_login: {name: "secret", scopes: ["current_user.show"]}
    )

    response.should send_json(401, logged_in: false)
  end
end
