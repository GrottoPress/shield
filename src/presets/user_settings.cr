{% skip_file if Avram::Model.all_subclasses
  .map(&.stringify)
  .includes?("UserOptions")
%}

{% skip_file unless Reference.subclasses
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
  class UserSettings
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
  class UserSettings
    include Shield::LoginUserSettings
  end

  class LogUserIn < Login::SaveOperation
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
