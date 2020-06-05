class User < BaseModel
  include Shield::User
  include Carbon::Emailable

  avram_enum Level do
    Admin
    Editor = 10
    Author = 20
  end

  table :users do
    column level : User::Level
  end

  authorize :delete do |user, record|
    user.level.admin?
  end

  authorize :create, :update do |user, record|
    user.level.admin? || user.id == record.try(&.id)
  end

  authorize :read do |user, record|
    user.level.admin? || user.id == record.try(&.id)
  end

  def emailable : Carbon::Address
    Carbon::Address.new(email)
  end
end
