module Shield::ActionHelpers
  macro included
    private def remote_ip : Socket::IPAddress?
      Socket::IPAddress.parse(request.remote_address.to_s)
    rescue
      nil
    end
  end
end
