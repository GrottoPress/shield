require "../../../../../spec_helper"

describe Shield::Api::Logins::Token::Verify do
  it "verifies login token" do
    password = "password4APASSWORD<"
    token = "a1b2c3"

    user = UserFactory.create &.password(password)
    UserOptionsFactory.create &.user_id(user.id)

    login = LoginFactory.create &.user_id(user.id).token(token)
    credentials = LoginCredentials.new(token, login.id)

    client = ApiClient.new
    client.api_auth(user, password)

    response = client.exec(Api::Logins::Token::Verify, token: credentials)
    response.should send_json(200, active: true)
  end

  it "rejects invalid login token" do
    password = "password4APASSWORD<"
    credentials = LoginCredentials.new("abcdef", 1)

    user = UserFactory.create &.password(password)
    UserOptionsFactory.create &.user_id(user.id)

    client = ApiClient.new
    client.api_auth(user, password)

    response = client.exec(Api::Logins::Token::Verify, token: credentials)
    response.should send_json(200, active: false)
  end

  it "requires logged in" do
    credentials = LoginCredentials.new("abcdef", 1)

    response = ApiClient.exec(Api::Logins::Token::Verify, token: credentials)
    response.should send_json(401, logged_in: false)
  end
end
