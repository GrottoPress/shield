class PasswordResetFactory < Avram::Factory
  def initialize
    set_defaults
  end

  def token(token : String)
    token_digest Sha256Hash.new(token).hash
  end

  private def set_defaults
    active_at Time.utc
    ip_address "1.2.3.4"
    success false
    token "123abcdefghijklmnopqrst"
  end
end
