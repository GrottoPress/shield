module Shield::ActionHelpers
  macro included
    def remote_ip : Socket::IPAddress?
      request.remote_address.as(Socket::IPAddress)
    rescue
    end

    def redirect_back(
      *,
      fallback : Lucky::Action.class,
      status : HTTP::Status,
      allow_external = false
    )
      redirect_back fallback: fallback.path,
        status: status.value,
        allow_external: allow_external
    end

    def redirect_back(
      *,
      fallback : Lucky::RouteHelper,
      status : HTTP::Status,
      allow_external = false
    )
      redirect_back fallback: fallback.path,
        status: status.value,
        allow_external: allow_external
    end

    def array_param(param_key, param) : Array(String)
      if request.headers["Content-Type"]?.try &.includes?("/json")
        params.from_json[param_key.to_s][param.to_s].as_a.map(&.to_s)
      else
        params.from_form_data.fetch_all("#{param_key}:#{param}")
      end
    rescue KeyError
      Array(String).new
    end
  end
end
