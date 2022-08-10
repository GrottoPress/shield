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

struct OauthClientSession
  include Shield::OauthClientSession
end
