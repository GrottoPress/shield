require "../../../spec_helper"

describe Shield::BearerLoginVerifier do
  describe "#verify" do
    it "verifies bearer login" do
      user = UserFactory.create
      UserOptionsFactory.create &.user_id(user.id)

      CreateBearerLogin.create(
        params(name: "some token"),
        user: user,
        scopes: [BearerScope.new(Api::Posts::Index).to_s],
      ) do |operation, bearer_login|
        bearer_login = bearer_login.not_nil!

        headers = HTTP::Headers.new

        BearerLoginCredentials.new(operation, bearer_login)
          .authenticate(headers)

        headers_2 = HTTP::Headers.new
        BearerLoginCredentials.new("abcdefghij", 1).authenticate(headers_2)

        BearerLoginHeaders.new(headers).verify.should be_a(BearerLogin)
        BearerLoginHeaders.new(headers_2).verify.should be_nil
      end
    end
  end
end
