class RemoveTokenFromLogins::V20200713142305 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(Login) do
      remove :token
    end
  end

  def rollback
    alter table_for(Login) do
      add token : String, fill_existing_with: Random::Secure.urlsafe_base64
    end
  end
end
