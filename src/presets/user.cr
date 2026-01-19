{% skip_file unless Avram::Model.all_subclasses.any?(&.name.== :User.id) %}

class UserQuery < User::BaseQuery
  include Shield::UserQuery
end

{% unless Avram::Model.all_subclasses.any?(&.name.== :EmailConfirmation.id) %}
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

class DeleteUser < User::DeleteOperation
  include Shield::DeleteUser
end

class UpdatePassword < User::SaveOperation
  include Shield::UpdatePassword
end

struct PasswordAuthentication
  include Shield::PasswordAuthentication
end
