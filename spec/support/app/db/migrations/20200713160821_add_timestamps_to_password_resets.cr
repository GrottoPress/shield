class AddTimestampsToPasswordResets::V20200713160821 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(PasswordReset) do
      add started_at : Time, fill_existing_with: Time.utc
      add ended_at : Time?
    end
  end

  def rollback
    alter table_for(PasswordReset) do
      remove :started_at
      remove :ended_at
    end
  end
end
