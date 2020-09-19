require "./user_options_box"

class UserBox < Avram::Box
  has_one user_options_box : UserOptionsBox

  def initialize
    set_defaults
  end

  private def set_defaults
    email "user@domain.tld"
    level User::Level.new(:author)
    password_digest CryptoHelper.hash_bcrypt("password12U~password")
  end
end
