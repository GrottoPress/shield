class EmailConfirmation < BaseModel
  include Shield::EmailConfirmation

  skip_default_columns
  primary_key id : Int64

  table :email_confirmations {}
end
