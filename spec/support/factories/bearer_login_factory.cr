class BearerLoginFactory < Avram::Factory
  def initialize
    set_defaults
  end

  def token(token : String)
    token_digest Sha256Hash.new(token).hash
  end

  private def set_defaults
    name "super secret"
    scopes ["api.posts.index"]
    active_at Time.utc
    token "123abcdefghijklmnopqrst"
  end
end
