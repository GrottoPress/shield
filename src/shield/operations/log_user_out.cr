module Shield::LogUserOut
  macro included
    include Shield::DeactivateLogin

    needs session : Lucky::Session

    before_save do
      set_status
    end

    after_commit delete_session

    private def set_status
      status.value = Login::Status.new(:ended)
    end

    private def delete_session(login : Login)
      Login.delete_session(session)
    end
  end
end
