# ameba:disable Style/TypeNames
class Rename_HashTo_Digest::V20200828163411 < Avram::Migrator::Migration::V1
  def migrate
    alter :logins do
      rename :token_hash, :token_digest
    end

    alter :password_resets do
      rename :token_hash, :token_digest
    end

    alter :users do
      rename :password_hash, :password_digest
    end
  end

  def rollback
    alter :logins do
      rename :token_digest, :token_hash
    end

    alter :password_resets do
      rename :token_digest, :token_hash
    end

    alter :users do
      rename :password_digest, :password_hash
    end
  end
end
