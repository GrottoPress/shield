module Shield::AuthenticationStatus
  macro included
    __enum Status do
      Started
      Ended
      Expired
    end
  end
end
