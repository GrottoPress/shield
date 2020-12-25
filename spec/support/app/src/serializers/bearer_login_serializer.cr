class BearerLoginSerializer < BaseSerializer
  def initialize(@bearer_login : BearerLogin)
  end

  def render
    {type: self.class.name, id: @bearer_login.id}
  end
end
