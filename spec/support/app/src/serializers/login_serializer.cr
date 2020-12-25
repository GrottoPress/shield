class LoginSerializer < BaseSerializer
  def initialize(@login : Login)
  end

  def render
    {type: self.class.name, id: @login.id}
  end
end
