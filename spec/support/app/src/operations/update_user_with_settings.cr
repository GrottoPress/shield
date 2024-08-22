class UpdateUserWithSettings < User::SaveOperation
  permit_columns :email, :level

  attribute password : String

  include Shield::SetPasswordDigestFromPassword
  include Shield::EndUserLoginsOnPasswordChange
  include Shield::SaveUserSettings
  include Shield::SaveBearerLoginUserSettings
  include Shield::SaveLoginUserSettings
  include Shield::SaveOauthClientUserSettings

  before_save do
    validate_required level
  end

  include Shield::ValidateUser
end
