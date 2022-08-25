class UserOptionsFactory < Avram::Factory
  def initialize
    set_defaults
  end

  private def set_defaults
    bearer_login_notify true
    login_notify true
    oauth_access_token_notify true
    password_notify true
  end
end
