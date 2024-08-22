{% skip_file unless Avram::Model.all_subclasses
  .find(&.name.== :EmailConfirmation.id)
%}

require "./common"

class EmailConfirmationQuery < EmailConfirmation::BaseQuery
  include Shield::EmailConfirmationQuery
end

class StartEmailConfirmation < EmailConfirmation::SaveOperation
  include Shield::StartEmailConfirmation
end

class EndEmailConfirmation < EmailConfirmation::SaveOperation
  include Shield::EndEmailConfirmation
end

class DeleteEmailConfirmation < EmailConfirmation::DeleteOperation
  include Shield::DeleteEmailConfirmation
end

class UpdateConfirmedEmail < EmailConfirmation::SaveOperation
  include Shield::UpdateConfirmedEmail
end

class EndCurrentUserEmailConfirmations < User::SaveOperation
  include Shield::EndUserEmailConfirmations
end

class DeleteCurrentUserEmailConfirmations < User::SaveOperation
  include Shield::DeleteUserEmailConfirmations
end

class EndUserEmailConfirmations < User::SaveOperation
  include Shield::EndUserEmailConfirmations
end

class DeleteUserEmailConfirmations < User::SaveOperation
  include Shield::DeleteUserEmailConfirmations
end

class RegisterCurrentUser < User::SaveOperation
  include Shield::RegisterEmailConfirmationUser
end

class UpdateCurrentUser < User::SaveOperation
  include Shield::UpdateEmailConfirmationUser
end

struct EmailConfirmationSession
  include Shield::EmailConfirmationSession
end

struct EmailConfirmationParams
  include Shield::EmailConfirmationParams
end

struct EmailConfirmationCredentials
  include Shield::EmailConfirmationCredentials
end
