module Shield::EndAuthentication(T, U)
  macro included
    needs session : Lucky::Session? = nil

    before_save do
      set_ended_at
      set_status
    end

    after_commit delete_session

    private def set_ended_at
      ended_at.value = Time.utc
    end

    private def set_status
      return unless status.value.in?({nil, T::Status.new(:started)})
      status.value = T::Status.new(:ended)
    end

    private def delete_session(saved_record : T)
      return if session.nil?
      U.new(session.not_nil!).delete
    end
  end
end
