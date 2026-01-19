module Shield::Api::SkipAuthenticationCache
  macro included
    include Shield::SkipAuthenticationCache

    def current_login? : Login?
      LoginHeaders.new(context).verify
    end

    {% if Avram::Model.all_subclasses.any?(&.name.== :BearerLogin.id) %}
      def current_bearer? : User?
        current_bearer_login?.try &.user
      end

      def current_bearer_login? : BearerLogin?
        BearerLoginHeaders.new(context).verify
      end
    {% end %}
  end
end
