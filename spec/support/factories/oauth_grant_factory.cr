class OauthGrantFactory < Avram::Factory
  def initialize
    set_defaults
  end

  def code(code : String)
    code_digest Sha256Hash.new(code).hash
  end

  private def set_defaults
    active_at Time.utc
    code "123abcdefghijklmnopqrst"
    scopes ["api.current_user.show"]
    success false
    type :authorization_code
  end
end
