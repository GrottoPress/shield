struct UserSettings
  include Shield::UserSettings
  include Shield::BearerLoginUserSettings
  include Shield::LoginUserSettings
  include Shield::OauthClientUserSettings
end
