require "../../../spec_helper"

describe Shield::BearerLoginVerifier do
  describe "#verify" do
    it "verifies bearer login" do
      scope = BearerScope.new(Api::Posts::Index).to_s
      token = "a1b2c3"

      developer = UserFactory.create
      oauth_client = OauthClientFactory.create &.user_id(developer.id)
      oauth_client_2 = OauthClientFactory.create &.user_id(developer.id)
      resource_owner = UserFactory.create &.email("resource@owner.com")

      bearer_login = BearerLoginFactory.create &.user_id(resource_owner.id)
        .oauth_client_id(oauth_client.id)
        .scopes([scope])
        .token(token)

      headers = HTTP::Headers.new
      BearerLoginCredentials.new(token, bearer_login.id).authenticate(headers)

      headers_2 = HTTP::Headers.new
      BearerLoginCredentials.new("abcdefghij", 1).authenticate(headers_2)

      BearerLoginHeaders.new(headers).verify(oauth_client, scope)
        .should(be_a BearerLogin)

      BearerLoginHeaders.new(headers).verify(oauth_client)
        .should(be_a BearerLogin)

      BearerLoginHeaders.new(headers).verify(scope).should be_a(BearerLogin)
      BearerLoginHeaders.new(headers).verify.should be_a(BearerLogin)

      BearerLoginHeaders.new(headers).verify(oauth_client_2, scope)
        .should(be_nil)

      BearerLoginHeaders.new(headers).verify(oauth_client, "api").should(be_nil)

      BearerLoginHeaders.new(headers).verify(oauth_client_2).should(be_nil)
      BearerLoginHeaders.new(headers).verify("api").should(be_nil)

      BearerLoginHeaders.new(headers_2).verify(oauth_client, scope)
        .should(be_nil)

      BearerLoginHeaders.new(headers_2).verify(oauth_client)
        .should(be_nil)

      BearerLoginHeaders.new(headers_2).verify(scope).should(be_nil)
      BearerLoginHeaders.new(headers_2).verify.should(be_nil)
    end
  end
end
