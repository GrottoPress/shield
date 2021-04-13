require "../../../../spec_helper"

describe Shield::Api::Logins::Destroy do
  it "revokes login" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    user = UserFactory.create &.email(email).password(password)
    UserOptionsFactory.create &.user_id(user.id)
    login = LoginFactory.create &.user_id(user.id)

    client = ApiClient.new
    client.api_auth(user, password)

    response = client.exec(Api::Logins::Destroy.with(login_id: login.id))

    response.should send_json(200, {status: "success"})
    login.reload.inactive?.should be_true
  end

  it "requires logged in" do
    response = ApiClient.exec(Api::Logins::Destroy.with(login_id: 1_i64))

    response.should send_json(401, logged_in: false)
  end
end
