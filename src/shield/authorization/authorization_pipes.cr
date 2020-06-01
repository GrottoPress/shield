module Shield::AuthorizationPipes
  macro included
    private def require_authorization
      if @authorized || logged_out?
        continue
      else
        raise Shield::AuthorizationNotPerformedError.new(
          "Authorization not performed for '#{self.class}' action"
        )
      end
    end
  end
end
