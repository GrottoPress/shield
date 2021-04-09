class AddTokenHashToLogins::V20200713142409 < Avram::Migrator::Migration::V1
  def migrate
    alter :logins do
      add token_hash : String, fill_existing_with: Random::Secure.urlsafe_base64
    end
  end

  def rollback
    alter :logins do
      remove :token_hash
    end
  end
end
