module Shield::OauthGrantMetadata
  macro included
    include Lucille::JSON

    getter code_challenge : String?
    getter code_challenge_method : String = OauthGrantPkce::METHOD_PLAIN
  end
end
