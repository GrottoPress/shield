{% skip_file unless Avram::Model.all_subclasses
  .map(&.stringify)
  .includes?("Login")
%}

class User < BaseModel
  include Shield::HasManyLogins
end

class LoginQuery < Login::BaseQuery
  include Shield::LoginQuery
end

class LogUserOut < Login::SaveOperation
  include Shield::LogUserOut
end

class LogUserIn < Login::SaveOperation
  include Shield::LogUserIn
end

class LogOutEverywhere < Login::SaveOperation
  include Shield::LogOutEverywhere
end

class DeleteLoginsEverywhere < Login::SaveOperation
  include Shield::DeleteLoginsEverywhere
end

class DeleteCurrentLogin < Login::DeleteOperation
  include Shield::DeleteLogin
end

class DeleteLogin < Login::DeleteOperation
  include Shield::DeleteLogin
end

abstract class BrowserAction < Lucky::Action
  include Shield::LoginHelpers
  include Shield::LoginPipes

  include Shield::AuthorizationHelpers
  include Shield::AuthorizationPipes
end

struct LoginSession
  include Shield::LoginSession
end

struct LoginIdleTimeoutSession
  include Shield::LoginIdleTimeoutSession
end
