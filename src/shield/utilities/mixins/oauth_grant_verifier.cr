module Shield::OauthGrantVerifier
  macro included
    include Shield::Verifier

    def verify!(
      oauth_client : OauthClient,
      oauth_grant_type : OauthGrantType,
      code_verifier : String? = nil
    )
      verify(oauth_client, oauth_grant_type, code_verifier).not_nil!
    end

    def verify(
      oauth_client : OauthClient,
      oauth_grant_type : OauthGrantType,
      code_verifier : String? = nil
    )
      yield self, verify(oauth_client, oauth_grant_type, code_verifier)
    end

    def verify(
      oauth_client : OauthClient,
      oauth_grant_type : OauthGrantType,
      code_verifier : String? = nil
    ) : OauthGrant?
      oauth_grant? if verify?(oauth_client, oauth_grant_type, code_verifier)
    end

    def verify?(
      oauth_client : OauthClient,
      oauth_grant_type : OauthGrantType,
      code_verifier : String? = nil
    ) : Bool?
      return unless oauth_grant_id? && oauth_grant_code?
      sha256 = Sha256Hash.new(oauth_grant_code)

      if (!code_verifier || verify_pkce?(code_verifier)) &&
        oauth_grant?.try(&.status.active?) &&
        oauth_grant.oauth_client_id == oauth_client.id &&
        oauth_grant.type == oauth_grant_type

        sha256.verify?(oauth_grant.code_digest)
      else
        sha256.fake_verify
      end
    end

    def verify_pkce?(code_verifier : String?) : Bool
      return false unless oauth_grant?

      oauth_grant.pkce.try do |pkce|
        return !!code_verifier.try { |verifier| pkce.verify?(verifier) }
      end

      oauth_grant.oauth_client.confidential?
    end

    def oauth_grant
      oauth_grant?.not_nil!
    end

    getter? oauth_grant : OauthGrant? do
      oauth_grant_id?.try do |id|
        OauthGrantQuery.new.id(id).preload_user.preload_oauth_client.first?
      end
    end

    def oauth_grant_id
      oauth_grant_id?.not_nil!
    end

    def oauth_grant_code : String
      oauth_grant_code?.not_nil!
    end
  end
end
