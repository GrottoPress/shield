class OauthClientFactory < Avram::Factory
  def initialize
    set_defaults
  end

  def secret(secret : String)
    secret_digest Sha256Hash.new(secret).hash
  end

  private def set_defaults
    active_at Time.utc
    name "Awesome Client"
    redirect_uri "https://example.com/oauth/callback"
  end
end
