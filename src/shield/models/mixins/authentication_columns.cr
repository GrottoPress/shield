module Shield::AuthenticationColumns
  macro included
    skip_default_columns

    primary_key id : Int64

    column token_digest : String
    column started_at : Time
    column ended_at : Time?

    def active? : Bool
      ended_at.nil? || ended_at.not_nil! > Time.utc
    end
  end
end
