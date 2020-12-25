class UserSerializer < BaseSerializer
  def initialize(@user : User)
  end

  def render
    {type: self.class.name, id: @user.id}
  end
end
