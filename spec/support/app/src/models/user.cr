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

  def emailable : Carbon::Address
    Carbon::Address.new(email)
  end
end
