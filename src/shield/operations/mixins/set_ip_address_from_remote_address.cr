module Shield::SetIpAddressFromRemoteAddress
  macro included
    needs remote_ip : Socket::IPAddress?

    before_save do
      set_ip_address
    end

    private def set_ip_address
      remote_ip.try { |ip| ip_address.value = ip.address }
    end
  end
end
