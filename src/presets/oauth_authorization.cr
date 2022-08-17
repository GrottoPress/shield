{% skip_file unless Avram::Model.all_subclasses
  .map(&.stringify)
  .includes?("OauthAuthorization")
%}

class User < BaseModel
  include Shield::HasManyOauthAuthorizations
end

class OauthClient < BaseModel
  include Shield::HasManyOauthAuthorizations
end

struct OauthAuthorizationPkce
  include Shield::OauthAuthorizationPkce
end

class OauthAuthorizationQuery < OauthAuthorization::BaseQuery
  include Shield::OauthAuthorizationQuery
end

class DeactivateOauthClient < OauthClient::SaveOperation
  include Shield::EndOauthAuthAuthorizationsAfterDeactivateOauthClient
end

class StartOauthAuthorization < OauthAuthorization::SaveOperation
  include Shield::StartOauthAuthorization
end

class EndOauthAuthorization < OauthAuthorization::SaveOperation
  include Shield::EndOauthAuthorization
end

class DeleteOauthAuthorization < OauthAuthorization::DeleteOperation
  include Shield::DeleteOauthAuthorization
end

class EndCurrentUserOauthAuthorizations < User::SaveOperation
  include Shield::EndUserOauthAuthorizations
end

class DeleteCurrentUserOauthAuthorizations < User::SaveOperation
  include Shield::DeleteUserOauthAuthorizations
end

class EndUserOauthAuthorizations < User::SaveOperation
  include Shield::EndUserOauthAuthorizations
end

class DeleteUserOauthAuthorizations < User::SaveOperation
  include Shield::DeleteUserOauthAuthorizations
end

class CreateOauthAccessToken < BearerLogin::SaveOperation
  include Shield::CreateOauthAccessToken
end

struct OauthAuthorizationStateSession
  include Shield::OauthAuthorizationStateSession
end

struct OauthAuthorizationCredentials
  include Shield::OauthAuthorizationCredentials
end

struct OauthAuthorizationParams
  include Shield::OauthAuthorizationParams
end
