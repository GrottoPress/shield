class User < BaseModel
  include Shield::User
  include Shield::UserSettingsColumn

  include Shield::HasOneUserOptions
  include Shield::HasManyBearerLogins
  include Shield::HasManyEmailConfirmations
  include Shield::HasManyLogins
  include Shield::HasManyOauthGrants
  include Shield::HasManyOauthClients
  include Shield::HasManyPasswordResets

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
