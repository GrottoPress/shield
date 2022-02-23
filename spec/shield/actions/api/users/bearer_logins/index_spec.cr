require "../../../../../spec_helper"

describe Shield::Api::Users::BearerLogins::Index do
  it "deletes bearer logins" do
    password = "password4APASSWORD<"

    user = UserFactory.create &.email("nobody@domain.com")
    admin = UserFactory.create &.level(:admin).password(password)
    UserOptionsFactory.create &.user_id(user.id)
    UserOptionsFactory.create &.user_id(admin.id)

    client = ApiClient.new
    client.api_auth(admin, password)

    response = client.exec(
      Api::Users::BearerLogins::Index.with(user_id: user.id)
    )

    response.should send_json(200, {status: "success"})
  end

  it "requires logged in" do
    response = ApiClient.exec(Api::Users::BearerLogins::Index.with(user_id: 6))

    response.should send_json(401, logged_in: false)
  end
end
