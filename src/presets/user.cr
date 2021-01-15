{% skip_file unless Avram::Model.all_subclasses
  .map(&.stringify)
  .includes?("User")
%}

class UserQuery < User::BaseQuery
  include Shield::UserQuery
end

{% unless Avram::Model.all_subclasses
  .map(&.stringify)
  .includes?("EmailConfirmation") %}

  class RegisterCurrentUser < User::SaveOperation
    include Shield::RegisterUser
  end

  class UpdateCurrentUser < User::SaveOperation
    include Shield::UpdateUser
  end
{% end %}

class RegisterUser < User::SaveOperation
  include Shield::RegisterUser
end

class UpdateUser < User::SaveOperation
  include Shield::UpdateUser
end

class DeleteUser < Avram::Operation
  include Shield::DeleteUser
end

struct PasswordAuthentication
  include Shield::PasswordAuthentication
end
