# class RegisterCurrentUserWithSettings < User::SaveOperation
#   before_save set_level

#   include Shield::RegisterUser
#   include Shield::SaveUserSettings
#   include Shield::SaveBearerLoginUserSettings
#   include Shield::SaveLoginUserSettings
#   include Shield::SaveOauthClientUserSettings

#   private def set_level
#     level.value = User::Level.new(:author)
#   end
# end
