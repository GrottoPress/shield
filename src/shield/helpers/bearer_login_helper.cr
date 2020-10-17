module Shield::BearerLoginHelper
  macro extended
    extend self

    def bearer_login_expired?(bearer_login : BearerLogin) : Bool
      (Time.utc - bearer_login.started_at) > Shield.settings.bearer_login_expiry
    end

    def token(
      bearer_login : BearerLogin,
      operation : CreateBearerLogin
    ) : String
      token(bearer_login.id, operation.token)
    end

    def token(id, token : String) : String
      LoginHelper.token(id, token)
    end

    def bearer_header(
      bearer_login : BearerLogin,
      operation : CreateBearerLogin
    ) : String
      bearer_header(bearer_login.id, operation.token)
    end

    def bearer_header(id, token : String)
      LoginHelper.bearer_header(id, token)
    end

    def token_from_headers(request : HTTP::Request)
      token_from_headers(request.headers)
    end

    # Expects "Authorization" header of format:
    # "Authorization: Bearer <ID>.<TOKEN>",
    # where <ID> = bearer login id, <TOKEN> = bearer login token
    def token_from_headers(headers : HTTP::Headers) : String?
      LoginHelper.token_from_headers(headers)
    end

    def scope(action : Lucky::Action.class) : String
      action.name.gsub("::", '.').underscore
    end

    def all_scopes : Array(String)
      actions = {{
        Lucky::Action
          .all_subclasses
          .reject(&.abstract?)
          .select { |k| k < Shield::ApiAction }
      }} of Lucky::Action.class

      actions.map { |action| scope(action) }
    end
  end
end
