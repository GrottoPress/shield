class AddTokenToLogin::V20200707121615 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(Login) do
      add token : String, fill_existing_with: Login.generate_token
    end
  end

  def rollback
    alter table_for(Login) do
      remove :token
    end
  end
end
