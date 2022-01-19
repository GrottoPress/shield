module Shield::LogOutEverywhere
  macro included
    needs skip_current : Bool

    after_save log_out_everywhere

    include Lucille::Deactivate

    private def set_inactive_at
      return if skip_current
      previous_def
    end

    private def log_out_everywhere(login : Shield::Login)
      LoginQuery.new
        .id.not.eq(login.id)
        .user_id(login.user_id)
        .is_active
        .update(inactive_at: Time.utc)
    end
  end
end
