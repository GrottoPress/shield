module Shield::DeleteSession
  macro included
    needs session : Lucky::Session?

    {% if @type < Avram::SaveOperation %}
      after_commit delete_session
    {% elsif @type < Avram::DeleteOperation %}
      after_delete delete_session
    {% elsif @type < Avram::Operation %}
      after_run delete_session
    {% end %}
  end
end
