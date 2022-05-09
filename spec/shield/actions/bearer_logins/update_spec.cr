require "../../../spec_helper"

describe Shield::BearerLogins::Update do
  it "updates bearer login" do
    password = "password4APASSWORD<"

    user = UserFactory.create &.password(password)
    UserOptionsFactory.create &.user_id(user.id)

    bearer_login = BearerLoginFactory.create &.user_id(user.id)
      .name("secret")
      .scopes(["posts.update"])

    client = ApiClient.new
    client.browser_auth(user, password)

    response = client.exec(
      BearerLogins::Update.with(bearer_login_id: bearer_login.id),
      bearer_login: {name: "secret", scopes: ["api.current_user.show"]}
    )

    response.headers["X-Bearer-Login-ID"]?.should eq(bearer_login.id.to_s)
  end

  it "requires logged in" do
    response = ApiClient.exec(
      BearerLogins::Update.with(bearer_login_id: 22),
      bearer_login: {name: "secret", scopes: ["current_user.show"]}
    )

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
