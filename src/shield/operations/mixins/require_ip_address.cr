module Shield::RequireIPAddress
  macro included
    needs remote_ip : Socket::IPAddress?

    before_save do
      require_ip_address
      set_ip_address
    end

    private def require_ip_address
      return unless remote_ip.nil?
      ip_address.add_error("could not be determined")
    end

    private def set_ip_address
      remote_ip.try do |value|
        ip_address.value = value
      end
    end
  end
end
