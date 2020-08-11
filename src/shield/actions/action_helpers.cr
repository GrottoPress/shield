module Shield::ActionHelpers
  macro included
    def remote_ip : Socket::IPAddress?
      request.remote_address.as(Socket::IPAddress)
    rescue
    end

    def redirect_back(
      *,
      fallback : Lucky::Action.class,
      status : HTTP::Status
    )
      redirect_back fallback: fallback, status: status.value
    end

    def redirect_back(
      *,
      fallback : Lucky::RouteHelper,
      status : HTTP::Status
    )
      redirect_back fallback: fallback, status: status.value
    end
  end
end
