require "../../../../spec_helper"

describe Shield::Api::Logins::Delete do
  it "deletes login" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    user = UserFactory.create &.email(email).password(password)
    UserOptionsFactory.create &.user_id(user.id)
    login = LoginFactory.create &.user_id(user.id)

    client = ApiClient.new
    client.api_auth(user, password)

    response = client.exec(Api::Logins::Delete.with(login_id: login.id))

    response.should send_json(200, {status: "success"})
    LoginQuery.new.id(login.id).any?.should be_false
  end

  it "requires logged in" do
    response = ApiClient.exec(Api::Logins::Delete.with(login_id: 1_i64))

    response.should send_json(401, logged_in: false)
  end
end
