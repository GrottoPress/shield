class AddStatusToPasswordReset::V20200722210722 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(PasswordReset) do
      add status : String, fill_existing_with: "Ended"
    end
  end

  def rollback
    alter table_for(PasswordReset) do
      remove :status
    end
  end
end
