class AddStatusToLogin::V20200722205129 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(Login) do
      add status : String, fill_existing_with: "Succeeded"
    end
  end

  def rollback
    alter table_for(Login) do
      remove :status
    end
  end
end
