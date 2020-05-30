module Shield::AuthorizationPipes
  macro included
    private def require_authorization
      if logged_out? || @authorized
        continue
      else
        raise Shield::AuthorizationNotPerformedError.new(
          "Authorization not performed for '#{self.class}' action"
        )
      end
    end
  end
end
