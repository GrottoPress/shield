class RegisterUser < User::SaveOperation
  include Shield::RegisterUser

  permit_columns :level
end
