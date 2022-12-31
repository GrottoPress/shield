{% skip_file unless Avram::Model.all_subclasses
  .find(&.name.== :UserOptions.id)
%}

class User < BaseModel
  include Shield::HasOneUserOptions
end

class UserOptionsQuery < UserOptions::BaseQuery
  include Shield::UserOptionsQuery
end

class SaveUserOptions < UserOptions::SaveOperation
  include Shield::SaveUserOptions
end

class RegisterCurrentUser < User::SaveOperation
  include Shield::HasOneSaveUserOptions
end

class RegisterUser < User::SaveOperation
  include Shield::HasOneSaveUserOptions
end

class UpdateCurrentUser < User::SaveOperation
  include Shield::HasOneSaveUserOptions
  include Shield::NotifyPasswordChange
end

class UpdateUser < User::SaveOperation
  include Shield::HasOneSaveUserOptions
end

{% if Avram::Model.all_subclasses.find(&.name.== :Login.id) %}
  class SaveUserOptions < UserOptions::SaveOperation
    include Shield::SaveLoginUserOptions
  end

  class StartCurrentLogin < Login::SaveOperation
    include Shield::NotifyLogin
  end
{% end %}

{% if Avram::Model.all_subclasses.find(&.name.== :BearerLogin.id) %}
  class SaveUserOptions < UserOptions::SaveOperation
    include Shield::SaveBearerLoginUserOptions
  end

  class CreateBearerLogin < BearerLogin::SaveOperation
    include Shield::NotifyBearerLogin
  end
{% end %}

{% if Avram::Model.all_subclasses.find(&.name.== :OauthGrant.id)  %}
  class CreateOauthAccessTokenFromGrant < BearerLogin::SaveOperation
    include Shield::NotifyOauthAccessToken
  end
{% end %}

{% if Avram::Model.all_subclasses.find(&.name.== :OauthClient.id) %}
  class CreateOauthAccessTokenFromClient < BearerLogin::SaveOperation
    include Shield::NotifyOauthAccessToken
  end

  class SaveUserOptions < UserOptions::SaveOperation
    include Shield::SaveOauthClientUserOptions
  end
{% end %}
