{% skip_file unless Avram::Model.all_subclasses
  .map(&.stringify)
  .includes?("PasswordReset")
%}

class User < BaseModel
  include Shield::HasManyPasswordResets
end

class PasswordResetQuery < PasswordReset::BaseQuery
  include Shield::PasswordResetQuery
end

class StartPasswordReset < PasswordReset::SaveOperation
  include Shield::StartPasswordReset
end

class EndPasswordReset < PasswordReset::SaveOperation
  include Shield::EndPasswordReset
end

class DeletePasswordReset < PasswordReset::DeleteOperation
  include Shield::DeletePasswordReset
end

class ResetPassword < PasswordReset::SaveOperation
  include Shield::ResetPassword
end

class EndCurrentUserPasswordResets < User::SaveOperation
  include Shield::EndUserPasswordResets
end

class DeleteCurrentUserPasswordResets < User::SaveOperation
  include Shield::DeleteUserPasswordResets
end

abstract class BrowserAction < Lucky::Action
  include Shield::PasswordResetHelpers
  include Shield::PasswordResetPipes
end

abstract class ApiAction < Lucky::Action
  include Shield::Api::PasswordResetHelpers
  include Shield::Api::PasswordResetPipes
end

struct PasswordResetSession
  include Shield::PasswordResetSession
end

struct PasswordResetParams
  include Shield::PasswordResetParams
end

struct PasswordResetUrl
  include Shield::PasswordResetUrl
end
