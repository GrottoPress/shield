class UserOptionsBox < Avram::Box
  def initialize
    set_defaults
  end

  private def set_defaults
    login_notify true
    password_notify true
  end
end
