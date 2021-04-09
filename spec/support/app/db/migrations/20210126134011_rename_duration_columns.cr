class RenameDurationColumns::V20210126134011 < Avram::Migrator::Migration::V1
  def migrate
    alter :bearer_logins do
      rename :started_at, :active_at
      rename :ended_at, :inactive_at
    end

    alter :email_confirmations do
      rename :started_at, :active_at
      rename :ended_at, :inactive_at
    end

    alter :logins do
      rename :started_at, :active_at
      rename :ended_at, :inactive_at
    end

    alter :password_resets do
      rename :started_at, :active_at
      rename :ended_at, :inactive_at
    end
  end

  def rollback
    alter :bearer_logins do
      rename :active_at, :started_at
      rename :inactive_at, :ended_at
    end

    alter :email_confirmations do
      rename :active_at, :started_at
      rename :inactive_at, :ended_at
    end

    alter :logins do
      rename :active_at, :started_at
      rename :inactive_at, :ended_at
    end

    alter :password_resets do
      rename :active_at, :started_at
      rename :inactive_at, :ended_at
    end
  end
end
