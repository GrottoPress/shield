module Shield::HttpClient
  macro included
    def api_auth(token : Shield::BearerToken)
      token.authenticate(client)
    end
  end
end
