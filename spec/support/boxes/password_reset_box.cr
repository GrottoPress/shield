class PasswordResetBox < Avram::Box
  def initialize
    set_defaults
  end

  def token(token : String)
    token_digest Sha256Hash.new(token).hash
  end

  private def set_defaults
    ip_address "1.2.3.4"
    started_at Time.utc
    token "123.abcdefghijklmnopqrst"
  end
end
