module Shield::OauthAuthorizationPkce
  macro included
    include Lucille::JSON

    getter code_challenge : String = ""
    getter code_challenge_method : String = "plain"
  end
end
