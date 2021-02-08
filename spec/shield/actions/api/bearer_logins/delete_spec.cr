require "../../../../spec_helper"

describe Shield::Api::BearerLogins::Delete do
  it "deletes bearer login" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    user = UserFactory.create &.email(email).password(password)
    UserOptionsFactory.create &.user_id(user.id)
    bearer_login = BearerLoginFactory.create &.user_id(user.id)

    client = ApiClient.new
    client.api_auth(user, password)

    response = client.exec(Api::BearerLogins::Delete.with(
      bearer_login_id: bearer_login.id
    ))

    response.should send_json(200, {status: "success"})
    BearerLoginQuery.new.id(bearer_login.id).first?.should be_nil
  end

  it "requires logged in" do
    response = ApiClient.exec(Api::BearerLogins::Delete.with(
      bearer_login_id: 1_i64
    ))

    response.should send_json(401, logged_in: false)
  end
end
