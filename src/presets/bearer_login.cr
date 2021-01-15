{% skip_file unless Avram::Model.all_subclasses
  .map(&.stringify)
  .includes?("BearerLogin")
%}

class User < BaseModel
  include Shield::HasManyBearerLogins
end

class BearerLoginQuery < BearerLogin::BaseQuery
  include Shield::BearerLoginQuery
end

class CreateBearerLogin < BearerLogin::SaveOperation
  include Shield::CreateBearerLogin
end

class RevokeBearerLogin < BearerLogin::SaveOperation
  include Shield::RevokeBearerLogin
end

class DeleteBearerLogin < Avram::Operation
  include Shield::DeleteBearerLogin
end

abstract class ApiAction < Lucky::Action
  include Shield::Api::LoginHelpers
  include Shield::Api::LoginPipes

  include Shield::Api::AuthorizationHelpers
  include Shield::Api::AuthorizationPipes
end

struct BearerLoginHeaders
  include Shield::BearerLoginHeaders
end

struct LoginHeaders
  include Shield::LoginHeaders
end

{% if Avram::Model.all_subclasses
  .map(&.stringify)
  .includes?("EmailConfirmation") %}

  abstract class ApiAction < Lucky::Action
    include Shield::Api::EmailConfirmationHelpers
    include Shield::Api::EmailConfirmationPipes
  end

  struct EmailConfirmationParams
    include Shield::EmailConfirmationParams
  end
{% end %}

{% if Avram::Model.all_subclasses.map(&.stringify).includes?("PasswordReset") %}
  abstract class ApiAction < Lucky::Action
    include Shield::Api::PasswordResetHelpers
    include Shield::Api::PasswordResetPipes
  end

  struct PasswordResetParams
    include Shield::PasswordResetParams
  end
{% end %}
