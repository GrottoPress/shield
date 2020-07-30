class User < BaseModel
  include Shield::User
  include Carbon::Emailable

  __enum Level do
    Admin
    Editor
    Author
  end

  table :users do
    column level : User::Level
  end

  authorize :delete do |user, record|
    user.level.admin?
  end

  authorize :create, :read, :update do |user, record|
    user.level.admin? || user.id == record.try(&.id)
  end

  def emailable : Carbon::Address
    Carbon::Address.new(email)
  end
end
