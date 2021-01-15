{% skip_file unless Avram::Model.all_subclasses
  .map(&.stringify)
  .includes?("EmailConfirmation")
%}

class User < BaseModel
  include Shield::HasManyEmailConfirmations
end

class EmailConfirmationQuery < EmailConfirmation::BaseQuery
  include Shield::EmailConfirmationQuery
end

class StartEmailConfirmation < EmailConfirmation::SaveOperation
  include Shield::StartEmailConfirmation
end

class EndEmailConfirmation < EmailConfirmation::SaveOperation
  include Shield::EndEmailConfirmation
end

class DeleteEmailConfirmation < Avram::Operation
  include Shield::DeleteEmailConfirmation
end

class RegisterCurrentUser < User::SaveOperation
  include Shield::RegisterEmailConfirmationUser
end

class UpdateCurrentUser < User::SaveOperation
  include Shield::UpdateEmailConfirmationUser
end

class UpdateConfirmedEmail < User::SaveOperation
  include Shield::UpdateConfirmedEmail
end

abstract class BrowserAction < Lucky::Action
  include Shield::EmailConfirmationHelpers
  include Shield::EmailConfirmationPipes
end

struct EmailConfirmationSession
  include Shield::EmailConfirmationSession
end

struct EmailConfirmationUrl
  include Shield::EmailConfirmationUrl
end
