module Shield::SaveEmail
  macro included
    include Shield::ValidateEmail

    before_save do
      validate_required email
      validate_uniqueness_of email
    end
  end
end
