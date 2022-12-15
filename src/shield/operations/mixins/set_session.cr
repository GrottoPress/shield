module Shield::SetSession
  macro included
    needs session : Lucky::Session?

    {% if @type < Avram::SaveOperation %}
      after_commit set_session
    {% elsif @type < Avram::DeleteOperation %}
      after_delete set_session
    {% elsif @type < Avram::Operation %}
      after_run set_session
    {% end %}
  end
end
