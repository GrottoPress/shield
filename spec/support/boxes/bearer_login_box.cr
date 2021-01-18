class BearerLoginBox < Avram::Box
  def initialize
    set_defaults
  end

  def token(token : String)
    token_digest Sha256Hash.new(token).hash
  end

  private def set_defaults
    name "super secret"
    scopes ["api.posts.index"]
    started_at Time.utc
    token "123.abcdefghijklmnopqrst"
  end
end
