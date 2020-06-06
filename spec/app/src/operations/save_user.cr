class SaveUser < User::SaveOperation
  include Shield::SaveUser

  permit_columns :level
end
