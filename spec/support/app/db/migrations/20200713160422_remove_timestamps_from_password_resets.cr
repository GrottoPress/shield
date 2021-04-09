class RemoveTimestampsFromPasswordResets::V20200713160422 < Avram::Migrator::Migration::V1
  def migrate
    alter :password_resets do
      remove :created_at
      remove :updated_at
    end
  end

  def rollback
    alter :password_resets do
      add_timestamps
    end
  end
end
