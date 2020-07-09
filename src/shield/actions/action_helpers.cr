module Shield::ActionHelpers
  macro included
    private def remote_ip : Socket::IPAddress?
      request.remote_address.as(Socket::IPAddress)
    rescue
      nil
    end
  end
end
