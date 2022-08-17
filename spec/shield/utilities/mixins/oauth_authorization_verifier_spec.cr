require "../../../spec_helper"

describe Shield::OauthAuthorizationVerifier do
  describe "#verify" do
    it "verifies OAuth authorization" do
      code_verifier = Random::Secure.urlsafe_base64(32)

      code_challenge = Base64.urlsafe_encode(
        Digest::SHA256.digest(code_verifier),
        false
      )

      developer = UserFactory.create
      oauth_client = OauthClientFactory.create &.user_id(developer.id)
      resource_owner = UserFactory.create &.email("resource@owner.com")

      StartOauthAuthorization.create(
        params(
          granted: true,
          code_challenge: code_challenge,
          code_challenge_method: "S256",
        ),
        scopes: [BearerScope.new(Api::Posts::Index).to_s],
        user: resource_owner,
        oauth_client: oauth_client
      ) do |operation, oauth_authorization|
        oauth_authorization.should be_a(OauthAuthorization)

        oauth_authorization.try do |_oauth_authorization|
          code = OauthAuthorizationCredentials.new(
            operation,
            _oauth_authorization
          ).to_s

          code_2 = OauthAuthorizationCredentials.new("abcdef", 4).to_s

          OauthAuthorizationParams.new(code)
            .verify(oauth_client, code_verifier)
            .should(be_a OauthAuthorization)

          OauthAuthorizationParams.new(code_2)
            .verify(oauth_client, code_verifier)
            .should(be_nil)
        end
      end
    end
  end
end
