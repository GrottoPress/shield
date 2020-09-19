class RegisterUser < User::SaveOperation
  include Shield::RegisterUser

  permit_columns :level

  before_save do
    validate_required level
  end
end
