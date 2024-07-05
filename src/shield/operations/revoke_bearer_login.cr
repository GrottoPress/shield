module Shield::RevokeBearerLogin # BearerLogin::SaveOperation
  macro included
    include Lucille::Deactivate
  end
end
