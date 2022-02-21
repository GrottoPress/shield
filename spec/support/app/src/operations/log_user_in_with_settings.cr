class LogUserInWithSettings < Login::SaveOperation
  include Shield::StartLogin
  include Shield::NotifyLoginIfSet
end
