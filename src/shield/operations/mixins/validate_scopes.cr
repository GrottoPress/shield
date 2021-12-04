module Shield::ValidateScopes
  macro included
    needs allowed_scopes : Array(String)

    before_save do
      validate_scopes_required
      validate_scopes_not_empty
      validate_scopes_valid
    end

    private def validate_scopes_required
      validate_required scopes,
        message: Rex.t(:"operation.error.bearer_scopes_required")
    end

    private def validate_scopes_not_empty
      scopes.value.try do |value|
        return unless value.empty?
        scopes.add_error Rex.t(:"operation.error.bearer_scopes_empty")
      end
    end

    private def validate_scopes_valid
      scopes.value.try do |value|
        return if value.all? &.in?(allowed_scopes)
        scopes.add_error Rex.t(:"operation.error.bearer_scopes_invalid")
      end
    end
  end
end
