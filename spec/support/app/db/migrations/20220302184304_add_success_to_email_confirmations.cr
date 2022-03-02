class AddSuccessToEmailConfirmations::V20220302184304 < Avram::Migrator::Migration::V1
  def migrate
    alter :email_confirmations do
      add success : Bool, fill_existing_with: false
    end
  end

  def rollback
    alter :email_confirmations do
      remove :success
    end
  end
end
