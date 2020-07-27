module Shield::SaveEmail
  macro included
    include Shield::ValidateEmail

    permit_columns :email

    before_save do
      validate_uniqueness_of email
    end
  end
end
