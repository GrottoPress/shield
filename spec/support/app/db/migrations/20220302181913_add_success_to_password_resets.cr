class AddSuccessToPasswordResets::V20220302181913 < Avram::Migrator::Migration::V1
  def migrate
    alter :password_resets do
      add success : Bool, fill_existing_with: false
    end
  end

  def rollback
    alter :password_resets do
      remove :success
    end
  end
end
