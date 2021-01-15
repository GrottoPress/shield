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

class DeletePasswordReset < Avram::Operation
  include Shield::DeletePasswordReset
end

class ResetPassword < User::SaveOperation
  include Shield::ResetPassword
end

abstract class BrowserAction < Lucky::Action
  include Shield::PasswordResetHelpers
  include Shield::PasswordResetPipes
end

struct PasswordResetSession
  include Shield::PasswordResetSession
end

struct PasswordResetUrl
  include Shield::PasswordResetUrl
end
