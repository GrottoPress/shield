class SaveUser < User::SaveOperation
  include Shield::SaveEmail
  include Shield::SavePassword

  permit_columns :level
end
