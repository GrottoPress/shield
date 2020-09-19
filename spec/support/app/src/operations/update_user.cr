class UpdateUser < User::SaveOperation
  include Shield::UpdateUser

  permit_columns :level

  before_save do
    validate_required level
  end
end
