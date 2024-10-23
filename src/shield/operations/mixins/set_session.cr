module Shield::SetSession
  macro included
    needs session : Lucky::Session?

    {% if @type < Avram::SaveOperation %}
      after_commit set_session
    {% elsif @type < Avram::DeleteOperation %}
      {% if compare_versions(Avram::VERSION, "1.3.0") >= 0 %}
        after_commit set_session
      {% else %}
        after_delete set_session
      {% end %}
    {% elsif @type < Avram::Operation %}
      after_run set_session
    {% end %}
  end
end
