module Shield::UpdateBearerLogin
  macro included
    permit_columns :name

    include Shield::ValidateBearerLogin
  end
end
