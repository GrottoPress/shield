{% skip_file unless Avram::Model.all_subclasses
  .find(&.name.== :OauthGrant.id)
%}

require "./common"

struct OauthGrantPkce
  include Shield::OauthGrantPkce
end

struct OauthGrantMetadata
  include Shield::OauthGrantMetadata
end

class OauthGrantQuery < OauthGrant::BaseQuery
  include Shield::OauthGrantQuery
end

class StartOauthGrant < OauthGrant::SaveOperation
  include Shield::StartOauthGrant
end

class EndOauthGrant < OauthGrant::SaveOperation
  include Shield::EndOauthGrant
end

class EndOauthGrantGracefully < OauthGrant::SaveOperation
  include Shield::EndOauthGrantGracefully
end

class RotateOauthGrant < OauthGrant::SaveOperation
  include Shield::RotateOauthGrant
end

class DeleteOauthGrant < OauthGrant::DeleteOperation
  include Shield::DeleteOauthGrant
end

class EndCurrentUserOauthGrants < User::SaveOperation
  include Shield::EndUserOauthGrants
end

class DeleteCurrentUserOauthGrants < User::SaveOperation
  include Shield::DeleteUserOauthGrants
end

class EndUserOauthGrants < User::SaveOperation
  include Shield::EndUserOauthGrants
end

class DeleteUserOauthGrants < User::SaveOperation
  include Shield::DeleteUserOauthGrants
end

class CreateOauthAccessTokenFromGrant < BearerLogin::SaveOperation
  include Shield::CreateOauthAccessTokenFromGrant
end

struct OauthStateSession
  include Shield::OauthStateSession
end

struct OauthGrantCredentials
  include Shield::OauthGrantCredentials
end

struct OauthGrantParams
  include Shield::OauthGrantParams
end
