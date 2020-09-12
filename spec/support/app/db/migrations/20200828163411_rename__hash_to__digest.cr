class Rename_HashTo_Digest::V20200828163411 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(Login) do
      rename :token_hash, :token_digest
    end

    alter table_for(PasswordReset) do
      rename :token_hash, :token_digest
    end

    alter table_for(User) do
      rename :password_hash, :password_digest
    end
  end

  def rollback
    alter table_for(Login) do
      rename :token_digest, :token_hash
    end

    alter table_for(PasswordReset) do
      rename :token_digest, :token_hash
    end

    alter table_for(User) do
      rename :password_digest, :password_hash
    end
  end
end
