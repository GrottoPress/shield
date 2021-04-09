class MakeTokenHashRequiredInPasswordResets::V20200713161604 < Avram::Migrator::Migration::V1
  def migrate
    make_required :password_resets, :token_hash
  end

  def rollback
    make_optional :password_resets, :token_hash
  end
end
