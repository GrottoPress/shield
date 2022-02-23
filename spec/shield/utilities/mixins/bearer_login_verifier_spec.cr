require "../../../spec_helper"

describe Shield::BearerLoginVerifier do
  describe "#verify" do
    it "verifies bearer login" do
      user = UserFactory.create
      UserOptionsFactory.create &.user_id(user.id)

      CreateCurrentUserBearerLogin.create(
        params(name: "some token"),
        user: user,
        scopes: ["posts.new", "posts.create"],
        allowed_scopes: ["posts.new", "posts.create"]
      ) do |operation, bearer_login|
        bearer_login = bearer_login.not_nil!

        headers = HTTP::Headers.new
        BearerToken.new(operation, bearer_login).authenticate(headers)

        headers_2 = HTTP::Headers.new
        BearerToken.new("abcdefghij", 1).authenticate(headers_2)

        BearerLoginHeaders.new(headers).verify.should be_a(BearerLogin)
        BearerLoginHeaders.new(headers_2).verify.should be_nil
      end
    end
  end
end
