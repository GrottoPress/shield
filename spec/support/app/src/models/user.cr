class User < BaseModel
  include Shield::User
  include Carbon::Emailable

  include Shield::HasOneUserOptions
  include Shield::HasManyBearerLogins
  include Shield::HasManyEmailConfirmations
  include Shield::HasManyLogins
  include Shield::HasManyPasswordResets

  __enum Level do
    Admin
    Editor
    Author
  end

  table :users do
    column level : User::Level
  end

  def emailable : Carbon::Address
    Carbon::Address.new(email)
  end
end
