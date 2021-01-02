require "./user_options_box"

class UserBox < Avram::Box
  has_one user_options_box : UserOptionsBox

  def initialize
    set_defaults
  end

  private def set_defaults
    email "user@domain.tld"
    level User::Level.new(:author)
    password_digest BcryptHash.new("password12U~password").hash
  end
end
