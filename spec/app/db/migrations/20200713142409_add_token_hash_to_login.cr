class AddTokenHashToLogin::V20200713142409 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(Login) do
      add token_hash : String, fill_existing_with: VerifyLogin.generate_token
    end
  end

  def rollback
    alter table_for(Login) do
      remove :token_hash
    end
  end
end
