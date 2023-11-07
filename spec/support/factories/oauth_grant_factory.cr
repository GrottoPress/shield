class OauthGrantFactory < Avram::Factory
  def initialize
    set_defaults
  end

  def code(code : String)
    code_digest Sha256Hash.new(code).hash
  end

  def pkce(challenge : String, challenge_method : String)
    code_challenge = "plain" == challenge_method ?
      OauthGrantPkce.hash(challenge) :
      challenge

    metadata({
      code_challenge: code_challenge,
      code_challenge_method: challenge_method,
      redirect_uri: "https://example.com/oauth/callback"
    })
  end

  def metadata(data : NamedTuple)
    metadata OauthGrantMetadata.from_json(data.to_json)
  end

  def redirect_uri(uri : String)
    metadata({redirect_uri: uri})
  end

  private def set_defaults
    active_at Time.utc
    code "123abcdefghijklmnopqrst"
    redirect_uri "https://example.com/oauth/callback"
    scopes ["api.current_user.show"]
    success false
    type :authorization_code
  end
end
