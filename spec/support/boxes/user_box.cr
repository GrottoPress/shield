class UserBox < Avram::Box
  def initialize
    set_defaults
  end

  private def set_defaults
    email "user@domain.tld"
    level User::Level.new(:author)
    password_digest BcryptHash.new("password12U~password").hash
  end
end
