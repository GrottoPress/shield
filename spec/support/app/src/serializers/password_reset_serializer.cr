struct PasswordResetSerializer < BaseSerializer
  def initialize(@password_reset : PasswordReset)
  end

  def render
    {type: self.class.name, id: @password_reset.id}
  end
end
