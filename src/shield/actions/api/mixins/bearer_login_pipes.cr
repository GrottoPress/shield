# Implements Bearer authentication as defined
# in [RFC 6750](https://tools.ietf.org/html/rfc6750)
#
# IMPORTANT!:
#   This module reduces `Shield::Api::LoginPipes` from an authentication
#   pipe to a delegated authorization pipe. Once included, bearer tokens
#   retrieved from the `Authorization` header MUST NOT be used as proof
#   of authentication.
module Shield::Api::BearerLoginPipes
  macro included
    include Shield::Api::LoginPipes

    private def send_invalid_token_response
      unless BearerLoginCredentials.from_headers?(request)
        response.status_code = 401
        return response.headers["WWW-Authenticate"] = %(Bearer)
      end

      if bearer_login_headers.verify?
        response.status_code = 403
        response.headers["WWW-Authenticate"] =
          %(Bearer error="insufficient_scope", scope="#{bearer_scope}")
      else
        response.status_code = 401
        response.headers["WWW-Authenticate"] = %(Bearer error="invalid_token")
      end
    end
  end
end
