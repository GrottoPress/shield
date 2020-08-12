module Shield::AuthenticationColumns(T)
  macro included
    include Shield::AuthenticationStatus

    skip_default_columns

    belongs_to user : User

    primary_key id : Int64

    column token_hash : String
    column ip_address : String
    column status : T::Status
    column started_at : Time
    column ended_at : Time?
  end
end
