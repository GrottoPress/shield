module Shield::RevokeBearerLogin
  macro included
    include Lucille::Deactivate
  end
end
