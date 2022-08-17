require "../../../spec_helper"

describe Shield::OauthClientVerifier do
  describe "#verify" do
    it "verifies OAuth client" do
      user = UserFactory.create

      CreateOauthClient.create(
        params(
          name: "Awesome Client",
          redirect_uri: "https://example.com/oauth/callback",
          public: false
        ),
        user: user
      ) do |operation, oauth_client|
        oauth_client.should be_a(OauthClient)

        oauth_client.try do |_oauth_client|
          headers = HTTP::Headers.new

          OauthClientCredentials.new(operation, _oauth_client)
            .authenticate(headers)

          headers_2 = HTTP::Headers.new

          OauthClientCredentials.new("abcdefghij", UUID.random)
            .authenticate(headers_2)

          OauthClientHeaders.new(headers).verify.should be_a(OauthClient)
          OauthClientHeaders.new(headers_2).verify.should be_nil
        end
      end
    end
  end
end
