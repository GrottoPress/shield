module Shield::OauthGrantParams
  macro included
    include Shield::OauthGrantVerifier

    def initialize(@code : String?)
    end

    def oauth_grant_id?
      credentials?.try(&.id)
    end

    def oauth_grant_code? : String?
      credentials?.try(&.password)
    end

    private getter? credentials : OauthGrantCredentials? do
      OauthGrantCredentials.from_params?(@code)
    end
  end
end
