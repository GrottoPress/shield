class UpdateUser < User::SaveOperation
  permit_columns :level

  before_save do
    validate_required level
  end
end
