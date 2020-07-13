class RemoveTimestampsFromPasswordReset::V20200713160422 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(PasswordReset) do
      remove :created_at
      remove :updated_at
    end
  end

  def rollback
    alter table_for(PasswordReset) do
      add_timestamps
    end
  end
end
