class AddTokenToLogins::V20200707121615 < Avram::Migrator::Migration::V1
  def migrate
    alter :logins do
      add token : String, fill_existing_with: Random::Secure.urlsafe_base64
    end
  end

  def rollback
    alter :logins do
      remove :token
    end
  end
end
