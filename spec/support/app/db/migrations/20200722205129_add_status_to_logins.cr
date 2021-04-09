class AddStatusToLogins::V20200722205129 < Avram::Migrator::Migration::V1
  def migrate
    alter :logins do
      add status : String, fill_existing_with: "Succeeded"
    end
  end

  def rollback
    alter :logins do
      remove :status
    end
  end
end
