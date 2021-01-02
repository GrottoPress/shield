module Shield::ValidateScopes
  macro included
    needs allowed_scopes : Array(String)

    before_save do
      validate_required scopes
      validate_scopes
    end

    private def validate_scopes
      scopes.value.try do |value|
        scopes.add_error("is required") if value.empty?
        scopes.add_error("is invalid") unless value.all? &.in?(allowed_scopes)
      end
    end
  end
end
