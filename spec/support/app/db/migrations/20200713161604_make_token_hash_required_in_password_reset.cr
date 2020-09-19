class MakeTokenHashRequiredInPasswordReset::V20200713161604 < Avram::Migrator::Migration::V1
  def migrate
    make_required table_for(PasswordReset), :token_hash
  end

  def rollback
    make_optional table_for(PasswordReset), :token_hash
  end
end
