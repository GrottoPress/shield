module Shield::DeleteSession
  macro included
    needs session : Lucky::Session?

    {% if @type < Avram::SaveOperation %}
      after_commit delete_session
    {% elsif @type < Avram::DeleteOperation %}
      {% if compare_versions(Avram::VERSION, "1.3.0") >= 0 %}
        after_commit delete_session
      {% else %}
        after_delete delete_session
      {% end %}
    {% elsif @type < Avram::Operation %}
      after_run delete_session
    {% end %}
  end
end
