class RemoveStatus::V20201025222325 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(BearerLogin) do
      remove :status
    end

    alter table_for(EmailConfirmation) do
      remove :status
    end

    alter table_for(Login) do
      remove :status
    end

    alter table_for(PasswordReset) do
      remove :status
    end
  end

  def rollback
    alter table_for(BearerLogin) do
      add status : String, fill_existing_with: "Ended"
    end

    alter table_for(EmailConfirmation) do
      add status : String, fill_existing_with: "Ended"
    end

    alter table_for(Login) do
      add status : String, fill_existing_with: "Ended"
    end

    alter table_for(PasswordReset) do
      add status : String, fill_existing_with: "Ended"
    end
  end
end
