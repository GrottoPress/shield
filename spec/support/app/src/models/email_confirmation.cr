class EmailConfirmation < BaseModel
  include Shield::EmailConfirmation

  table :email_confirmations {}
end
