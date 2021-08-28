module Shield::ValidateScopes
  macro included
    needs allowed_scopes : Array(String)

    before_save do
      validate_scopes_required
      validate_scopes_valid
    end

    private def validate_scopes_required
      validate_required scopes

      scopes.value.try do |value|
        scopes.add_error("is required") if value.empty?
      end
    end

    private def validate_scopes_valid
      scopes.value.try do |value|
        scopes.add_error("is invalid") unless value.all? &.in?(allowed_scopes)
      end
    end
  end
end
