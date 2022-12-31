{% skip_file unless Avram::Model.all_subclasses
  .find(&.name.== :PasswordReset.id)
%}

require "../compat/password_reset"

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

class EndUserPasswordResets < User::SaveOperation
  include Shield::EndUserPasswordResets
end

class DeleteUserPasswordResets < User::SaveOperation
  include Shield::DeleteUserPasswordResets
end

struct PasswordResetSession
  include Shield::PasswordResetSession
end

struct PasswordResetParams
  include Shield::PasswordResetParams
end

struct PasswordResetCredentials
  include Shield::PasswordResetCredentials
end
