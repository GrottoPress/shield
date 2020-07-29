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
      if value = remote_ip
        ip_address.value = value.not_nil!
      else
        # So that *Avram*'s `validate_required ip_address` passes.
        # We've already taken care of this validation with
        # `require_ip_address`, because we needed a custom error message
        ip_address.value = Socket::IPAddress.new("0.0.0.0", 0)
      end
    end
  end
end
