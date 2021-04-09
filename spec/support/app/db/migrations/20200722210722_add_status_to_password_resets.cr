class AddStatusToPasswordResets::V20200722210722 < Avram::Migrator::Migration::V1
  def migrate
    alter :password_resets do
      add status : String, fill_existing_with: "Ended"
    end
  end

  def rollback
    alter :password_resets do
      remove :status
    end
  end
end
