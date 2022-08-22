require "../../../../spec_helper"

describe Shield::Api::BearerLogins::Verify do
  it "verifies bearer login" do
    user = UserFactory.create
    UserOptionsFactory.create &.user_id(user.id)

    CreateBearerLogin.create(
      params(name: "Secret token"),
      scopes: [BearerScope.new(Api::Posts::Index).to_s],
      user: user
    ) do |operation, bearer_login|
      bearer_login.should be_a(BearerLogin)

      bearer_login.try do |_bearer_login|
        token = BearerLoginCredentials.new(operation, _bearer_login)

        response = ApiClient.exec(Api::BearerLogins::Verify, token: token)

        response.should send_json(200, {
          message: "action.bearer_login.verify.success"
        })
      end
    end
  end

  it "rejects invalid bearer login token" do
    token = BearerLoginCredentials.new("abcdef", 1)

    response = ApiClient.exec(Api::BearerLogins::Verify, token: token)
    response.should send_json(200, {status: "failure"})
  end
end
