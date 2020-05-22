module Shield::LogUserOut
  macro included
    needs session : Lucky::Session
    needs cookies : Lucky::CookieJar

    before_save do
      set_status
      set_ended_at
    end

    after_commit delete_session

    private def set_status
      status.value = Login::Status.new(:inactive)
    end

    private def set_ended_at
      ended_at.value = Time.utc
    end

    private def delete_session(login : Login)
      Login.delete_session(session, cookies)
    end
  end
end
