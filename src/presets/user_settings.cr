{% skip_file if Avram::Model.all_subclasses
  .map(&.stringify)
  .includes?("UserOptions")
%}

{% skip_file unless Lucille::JSON.includers
  .map(&.stringify)
  .includes?("UserSettings")
%}

class RegisterCurrentUser < User::SaveOperation
  include Shield::SaveUserSettings
end

class UpdateCurrentUser < User::SaveOperation
  include Shield::SaveUserSettings
  include Shield::NotifyPasswordChangeIfSet
end

class RegisterUser < User::SaveOperation
  include Shield::SaveUserSettings
end

class UpdateUser < User::SaveOperation
  include Shield::SaveUserSettings
end

{% if Avram::Model.all_subclasses.map(&.stringify).includes?("BearerLogin") %}
  struct UserSettings
    include Shield::BearerLoginUserSettings
  end

  class CreateBearerLogin < BearerLogin::SaveOperation
    include Shield::NotifyBearerLoginIfSet
  end

  class RegisterCurrentUser < User::SaveOperation
    include Shield::SaveBearerLoginUserSettings
  end

  class UpdateCurrentUser < User::SaveOperation
    include Shield::SaveBearerLoginUserSettings
  end

  class RegisterUser < User::SaveOperation
    include Shield::SaveBearerLoginUserSettings
  end

  class UpdateUser < User::SaveOperation
    include Shield::SaveBearerLoginUserSettings
  end
{% end %}

{% if Avram::Model.all_subclasses.map(&.stringify).includes?("Login") %}
  struct UserSettings
    include Shield::LoginUserSettings
  end

  class StartCurrentLogin < Login::SaveOperation
    include Shield::NotifyLoginIfSet
  end

  class RegisterCurrentUser < User::SaveOperation
    include Shield::SaveLoginUserSettings
  end

  class UpdateCurrentUser < User::SaveOperation
    include Shield::SaveLoginUserSettings
  end

  class RegisterUser < User::SaveOperation
    include Shield::SaveLoginUserSettings
  end

  class UpdateUser < User::SaveOperation
    include Shield::SaveLoginUserSettings
  end
{% end %}

{% if Avram::Model.all_subclasses
  .map(&.stringify)
  .includes?("OauthAuthorization") %}

  class CreateOauthAccessTokenFromAuthorization < BearerLogin::SaveOperation
    include Shield::NotifyOauthAccessTokenIfSet
  end
{% end %}

{% if Avram::Model.all_subclasses.map(&.stringify).includes?("OauthClient") %}
  struct UserSettings
    include Shield::OauthClientUserSettings
  end

  class RegisterCurrentUser < User::SaveOperation
    include Shield::SaveOauthClientUserSettings
  end

  class UpdateCurrentUser < User::SaveOperation
    include Shield::SaveOauthClientUserSettings
  end

  class RegisterUser < User::SaveOperation
    include Shield::SaveOauthClientUserSettings
  end

  class UpdateUser < User::SaveOperation
    include Shield::SaveOauthClientUserSettings
  end
{% end %}
