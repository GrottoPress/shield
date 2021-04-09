class MakeIpAddressRequired::V20200722145914 < Avram::Migrator::Migration::V1
  def migrate
    make_required :logins, :ip_address
    make_required :password_resets, :ip_address
  end

  def rollback
    make_optional :logins, :ip_address
    make_optional :password_resets, :ip_address
  end
end
