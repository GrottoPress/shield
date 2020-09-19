class MakeIpAddressRequired::V20200722145914 < Avram::Migrator::Migration::V1
  def migrate
    make_required table_for(Login), :ip_address
    make_required table_for(PasswordReset), :ip_address
  end

  def rollback
    make_optional table_for(Login), :ip_address
    make_optional table_for(PasswordReset), :ip_address
  end
end
