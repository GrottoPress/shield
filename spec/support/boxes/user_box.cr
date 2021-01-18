class UserBox < Avram::Box
  def initialize
    set_defaults
  end

  def password(password : String)
    password_digest BcryptHash.new(password).hash
  end

  private def set_defaults
    email "user@domain.tld"
    level User::Level.new(:author)
    password "password12U~password"
  end
end
