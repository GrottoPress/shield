class RenameDurationColumns::V20210126134011 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(BearerLogin) do
      rename :started_at, :active_at
      rename :ended_at, :inactive_at
    end

    alter table_for(EmailConfirmation) do
      rename :started_at, :active_at
      rename :ended_at, :inactive_at
    end

    alter table_for(Login) do
      rename :started_at, :active_at
      rename :ended_at, :inactive_at
    end

    alter table_for(PasswordReset) do
      rename :started_at, :active_at
      rename :ended_at, :inactive_at
    end
  end

  def rollback
    alter table_for(BearerLogin) do
      rename :active_at, :started_at
      rename :inactive_at, :ended_at
    end

    alter table_for(EmailConfirmation) do
      rename :active_at, :started_at
      rename :inactive_at, :ended_at
    end

    alter table_for(Login) do
      rename :active_at, :started_at
      rename :inactive_at, :ended_at
    end

    alter table_for(PasswordReset) do
      rename :active_at, :started_at
      rename :inactive_at, :ended_at
    end
  end
end
