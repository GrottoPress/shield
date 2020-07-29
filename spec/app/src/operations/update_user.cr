class UpdateUser < User::SaveOperation
  include Shield::UpdateUser

  permit_columns :level
end
