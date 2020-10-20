class LogUserIn < Login::SaveOperation
  include Shield::LogUserIn
  include Shield::NotifyLogin
end
