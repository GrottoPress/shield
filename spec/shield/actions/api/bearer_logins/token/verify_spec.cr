require "../../../../../spec_helper"

describe Shield::Api::BearerLogins::Token::Verify do
  it "verifies bearer login" do
    password = "password4APASSWORD<"
    token = "a1b2c3"

    user = UserFactory.create &.password(password)
    UserOptionsFactory.create &.user_id(user.id)

    bearer_login = BearerLoginFactory.create &.user_id(user.id).token(token)
    credentials = BearerLoginCredentials.new(token, bearer_login.id)

    client = ApiClient.new
    client.api_auth(user, password)

    response = client.exec(Api::BearerLogins::Token::Verify, token: credentials)

    response.should send_json(200, active: true)
  end

  it "rejects invalid bearer login token" do
    password = "password4APASSWORD<"
    credentials = BearerLoginCredentials.new("abcdef", 1)

    user = UserFactory.create &.password(password)
    UserOptionsFactory.create &.user_id(user.id)

    client = ApiClient.new
    client.api_auth(user, password)

    response = client.exec(Api::BearerLogins::Token::Verify, token: credentials)
    response.should send_json(200, active: false)
  end

  it "requires logged in" do
    credentials = BearerLoginCredentials.new("abcdef", 1)

    response = ApiClient.exec(
      Api::BearerLogins::Token::Verify,
      token: credentials
    )

    response.should send_json(401, logged_in: false)
  end
end
