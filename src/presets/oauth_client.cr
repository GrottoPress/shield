{% skip_file unless Avram::Model.all_subclasses
  .map(&.stringify)
  .includes?("OauthClient")
%}

class User < BaseModel
  include Shield::HasManyOauthClients
end

class BearerLogin < BaseModel
  include Shield::OptionalBelongsToOauthClient
end

class OauthClientQuery < OauthClient::BaseQuery
  include Shield::OauthClientQuery
end

class CreateOauthClient < OauthClient::SaveOperation
  include Shield::CreateOauthClient
end

class RefreshOauthClientSecret < OauthClient::SaveOperation
  include Shield::RefreshOauthClientSecret
end

class DeactivateOauthClient < OauthClient::SaveOperation
  include Shield::DeactivateOauthClient
end

class UpdateOauthClient < OauthClient::SaveOperation
  include Shield::UpdateOauthClient
end

class DeleteOauthClient < OauthClient::DeleteOperation
  include Shield::DeleteOauthClient
end

class DeactivateCurrentUserOauthClients < User::SaveOperation
  include Shield::DeactivateUserOauthClients
end

class DeleteCurrentUserOauthClients < User::SaveOperation
  include Shield::DeleteUserOauthClients
end

class DeactivateUserOauthClients < User::SaveOperation
  include Shield::DeactivateUserOauthClients
end

class DeleteUserOauthClients < User::SaveOperation
  include Shield::DeleteUserOauthClients
end

class RevokeCurrentUserOauthAccessTokens < User::SaveOperation
  include Shield::RevokeUserOauthAccessTokens
end

class DeleteCurrentUserOauthAccessTokens < User::SaveOperation
  include Shield::DeleteUserOauthAccessTokens
end

class RevokeUserOauthAccessTokens < User::SaveOperation
  include Shield::RevokeUserOauthAccessTokens
end

class DeleteUserOauthAccessTokens < User::SaveOperation
  include Shield::DeleteUserOauthAccessTokens
end

struct OauthClientSession
  include Shield::OauthClientSession
end

struct OauthClientHeaders
  include Shield::OauthClientHeaders
end

struct OauthClientParams
  include Shield::OauthClientParams
end

struct OauthClientCredentials
  include Shield::OauthClientCredentials
end
