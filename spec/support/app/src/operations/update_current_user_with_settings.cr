class UpdateCurrentUserWithSettings < User::SaveOperation
  permit_columns :email

  attribute password : String

  include Shield::SaveUserSettings
  include Shield::NotifyPasswordChangeIfSet
  include Shield::SaveBearerLoginUserSettings
  include Shield::SaveLoginUserSettings
  include Shield::SaveOauthClientUserSettings
  include Shield::SetPasswordDigestFromPassword
  include Shield::EndUserLoginsOnPasswordChange

  before_save do
    set_level
  end

  include Shield::ValidateUser

  private def set_level
    level.value = User::Level.new(:author)
  end
end
