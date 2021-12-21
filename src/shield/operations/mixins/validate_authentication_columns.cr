module Shield::ValidateAuthenticationColumns
  macro included
    before_save do
      validate_token_digest_required
    end

    include Lucille::ValidateStatus

    private def validate_token_digest_required
      validate_required token_digest,
        message: Rex.t(:"operation.error.token_required")
    end
  end
end
