class LogUserInWithSettings < Login::SaveOperation
  include Shield::LogUserIn
  include Shield::NotifyLoginIfSet
end
