{% skip_file unless Avram::Model.all_subclasses.any?(&.name.== :Login.id) %}

require "./common"

class LoginQuery < Login::BaseQuery
  include Shield::LoginQuery
end

class StartCurrentLogin < Login::SaveOperation
  include Shield::StartLogin
end

class EndCurrentLogin < Login::SaveOperation
  include Shield::EndLogin
end

class EndLogin < Login::SaveOperation
  include Shield::EndLogin
end

class LogOutEverywhere < User::SaveOperation
  include Shield::EndUserLogins
end

class DeleteLoginsEverywhere < User::SaveOperation
  include Shield::DeleteUserLogins
end

class EndCurrentUserLogins < User::SaveOperation
  include Shield::EndUserLogins
end

class DeleteCurrentUserLogins < User::SaveOperation
  include Shield::DeleteUserLogins
end

class EndUserLogins < User::SaveOperation
  include Shield::EndUserLogins
end

class DeleteUserLogins < User::SaveOperation
  include Shield::DeleteUserLogins
end

class DeleteCurrentLogin < Login::DeleteOperation
  include Shield::DeleteLogin
end

class DeleteLogin < Login::DeleteOperation
  include Shield::DeleteLogin
end

struct LoginSession
  include Shield::LoginSession
end

struct LoginHeaders
  include Shield::LoginHeaders
end

struct LoginParams
  include Shield::LoginParams
end

struct LoginIdleTimeoutSession
  include Shield::LoginIdleTimeoutSession
end

struct LoginCredentials
  include Shield::LoginCredentials
end
