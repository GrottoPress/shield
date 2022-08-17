# Implements the OAuth 2.0 authorization framework as defined
# in [RFC 6749](https://datatracker.ietf.org/doc/html/rfc6749)
module Shield::Api::OauthAccessTokenPipes
  macro included
    include Shield::OauthAccessTokenPipes
    include Shield::Api::OauthPipes
  end
end
