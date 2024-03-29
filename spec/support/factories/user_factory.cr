class UserFactory < Avram::Factory
  def initialize
    set_defaults
  end

  def password(password : String)
    password_digest BcryptHash.new(password).hash
  end

  def settings(data : NamedTuple)
    settings UserSettings.from_json(data.to_json)
  end

  private def set_defaults
    email "useR@dom4iN.TLd"
    level :author
    password "password12U~password"

    settings({
      bearer_login_notify: true,
      login_notify: true,
      oauth_access_token_notify: true,
      password_notify: true
    })
  end
end
