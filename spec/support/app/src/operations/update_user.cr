class UpdateUser < User::SaveOperation
  include Shield::UpdateUser
  include Shield::HasOneSaveUserOptions

  permit_columns :level

  before_save do
    validate_required level
  end
end
