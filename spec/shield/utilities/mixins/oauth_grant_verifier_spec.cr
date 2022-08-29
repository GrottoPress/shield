require "../../../spec_helper"

describe Shield::OauthGrantVerifier do
  describe "#verify" do
    it "verifies OAuth grant" do
      code = "a1b2c3"
      code_verifier = Random::Secure.urlsafe_base64(32)
      grant_type = OauthGrantType.new(OauthGrantType::AUTHORIZATION_CODE)
      grant_type_2 = OauthGrantType.new(OauthGrantType::REFRESH_TOKEN)

      code_challenge = Base64.urlsafe_encode(
        Digest::SHA256.digest(code_verifier),
        false
      )

      developer = UserFactory.create
      oauth_client = OauthClientFactory.create &.user_id(developer.id)
      oauth_client_2 = OauthClientFactory.create &.user_id(developer.id)
      resource_owner = UserFactory.create &.email("resource@owner.com")

      oauth_grant = OauthGrantFactory.create &.user_id(resource_owner.id)
        .oauth_client_id(oauth_client.id)
        .type(grant_type)
        .code(code)
        .metadata({
          code_challenge: code_challenge,
          code_challenge_method: "S256"
        }.to_json)

      code = OauthGrantCredentials.new(code, oauth_grant.id).to_s
      code_2 = OauthGrantCredentials.new("abcdef", 4).to_s

      OauthGrantParams.new(code)
        .verify(oauth_client, grant_type, code_verifier)
        .should(be_a OauthGrant)

      OauthGrantParams.new(code)
        .verify(oauth_client, grant_type)
        .should(be_a OauthGrant)

      OauthGrantParams.new(code)
        .verify(oauth_client_2, grant_type, code_verifier)
        .should(be_nil)

      OauthGrantParams.new(code)
        .verify(oauth_client_2, grant_type)
        .should(be_nil)

      OauthGrantParams.new(code)
        .verify(oauth_client, grant_type_2, code_verifier)
        .should(be_nil)

      OauthGrantParams.new(code)
        .verify(oauth_client, grant_type_2)
        .should(be_nil)

      OauthGrantParams.new(code)
        .verify(oauth_client, grant_type, "abc123")
        .should(be_nil)

      OauthGrantParams.new(code_2)
        .verify(oauth_client, grant_type, code_verifier)
        .should(be_nil)

      OauthGrantParams.new(code_2)
        .verify(oauth_client, grant_type)
        .should(be_nil)
    end
  end
end
