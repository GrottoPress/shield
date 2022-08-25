class RegisterUserWithSettings < User::SaveOperation
  permit_columns :level

  before_save do
    validate_required level
  end

  include Shield::RegisterUser
  include Shield::SaveUserSettings
  include Shield::SaveBearerLoginUserSettings
  include Shield::SaveLoginUserSettings
  include Shield::SaveOauthClientUserSettings
end
