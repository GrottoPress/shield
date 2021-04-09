class RemoveStatus::V20201025222325 < Avram::Migrator::Migration::V1
  def migrate
    alter :bearer_logins do
      remove :status
    end

    alter :email_confirmations do
      remove :status
    end

    alter :logins do
      remove :status
    end

    alter :password_resets do
      remove :status
    end
  end

  def rollback
    alter :bearer_logins do
      add status : String, fill_existing_with: "Ended"
    end

    alter :email_confirmations do
      add status : String, fill_existing_with: "Ended"
    end

    alter :logins do
      add status : String, fill_existing_with: "Ended"
    end

    alter :password_resets do
      add status : String, fill_existing_with: "Ended"
    end
  end
end
