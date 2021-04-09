class RemoveTokenFromLogins::V20200713142305 < Avram::Migrator::Migration::V1
  def migrate
    alter :logins do
      remove :token
    end
  end

  def rollback
    alter :logins do
      add token : String, fill_existing_with: Random::Secure.urlsafe_base64
    end
  end
end
