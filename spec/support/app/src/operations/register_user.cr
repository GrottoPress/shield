class RegisterUser < User::SaveOperation
  include Shield::RegisterUser
  include Shield::HasOneCreateSaveUserOptions

  permit_columns :level

  before_save do
    validate_required level
  end
end
