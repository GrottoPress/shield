module Shield::EndAuthentication(M)
  macro included
    before_save do
      set_ended_at
      set_status
    end

    private def set_ended_at
      ended_at.value = Time.utc
    end

    private def set_status
      return unless status.value.in?({nil, M::Status.new(:started)})
      status.value = M::Status.new(:ended)
    end
  end
end
