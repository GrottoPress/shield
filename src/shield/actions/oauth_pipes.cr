# Implements the OAuth 2.0 authorization framework as defined
# in [RFC 6749](https://datatracker.ietf.org/doc/html/rfc6749)
module Shield::OauthPipes
  macro included
    include Shield::OauthHelpers

    skip :check_authorization

    # TODO:
    #
    # This doesn't work; `Lucky::ErrorHandler` catches the error
    # before we get to this pipe. We should probably move this there.
    def oauth_handle_errors
      continue
    rescue error : Lucky::Error
      raise error
    rescue error
      response.status_code = 500
      do_oauth_handle_errors(error)
    end

    def oauth_check_duplicate_params
      if !has_duplicate_params
        continue
      else
        response.status_code = 400
        do_oauth_check_duplicate_params_failed
      end
    end

    def oauth_validate_client_id
      if oauth_client?
        continue
      else
        response.status_code = 400
        do_oauth_validate_client_id_failed
      end
    end

    def oauth_validate_scope
      allowed_scopes = Shield.settings.bearer_login_scopes_allowed

      if scopes.all?(&.in? allowed_scopes)
        continue
      else
        response.status_code = 400
        do_oauth_validate_scope_failed
      end
    end

    def oauth_validate_redirect_uri
      if !oauth_client? || oauth_client.redirect_uri == redirect_uri
        continue
      else
        response.status_code = 400
        do_oauth_validate_redirect_uri_failed
      end
    end

    private def has_duplicate_params
      params.from_query.any? { |name, _| name.size > 1 }
    end
  end
end
