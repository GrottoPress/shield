class RegisterUser < User::SaveOperation
  include Shield::RegisterUser
  include Shield::HasOneSaveUserOptions

  permit_columns :level

  before_save do
    validate_required level
  end
end
