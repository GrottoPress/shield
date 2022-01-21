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

class LogOutEverywhere < User::SaveOperation
  include Shield::LogOutEverywhere
end

class DeleteLoginsEverywhere < User::SaveOperation
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
end

abstract class ApiAction < Lucky::Action
  include Shield::Api::LoginHelpers
  include Shield::Api::LoginPipes
end

struct LoginSession
  include Shield::LoginSession
end

struct LoginHeaders
  include Shield::LoginHeaders
end

struct LoginIdleTimeoutSession
  include Shield::LoginIdleTimeoutSession
end
