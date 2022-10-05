module Shield::ValidateOauthClient
  macro included
    before_save do
      ensure_redirect_uris_unique
      limit_redirect_uris_count

      validate_name_required
      validate_name_unique
      validate_name_valid
      validate_name_allowed

      validate_redirect_uris_required
      validate_redirect_uris_not_empty
      validate_redirect_uris_valid

      validate_user_id_required
      validate_user_exists
    end

    include Lucille::ValidateStatus

    private def validate_name_required
      validate_required name,
        message: Rex.t(:"operation.error.name_required")
    end

    private def validate_name_unique
      return unless name.changed? || user_id.changed?

      name.value.try do |_name|
        user_id.value.try do |_user_id|
          if OauthClientQuery.new.user_id(_user_id).name(_name).is_active.any?
            name.add_error Rex.t(:"operation.error.name_exists", name: _name)
          end
        end
      end
    end

    private def validate_name_valid
      name.value.try do |value|
        return if value.matches?(/^[a-z\_][a-z0-9\s\_\-\(\)]*$/i)
        name.add_error Rex.t(:"operation.error.name_invalid", name: value)
      end
    end

    private def validate_name_allowed
      name.value.try do |value|
        return unless filter = Shield.settings.oauth_client_name_filter
        return unless value =~ filter

        name.add_error Rex.t(:"operation.error.name_not_allowed", name: value)
      end
    end

    private def validate_redirect_uris_required
      validate_required redirect_uris,
        message: Rex.t(:"operation.error.redirect_uris_required")
    end

    private def validate_redirect_uris_not_empty
      redirect_uris.value.try do |value|
        return unless value.empty?
        redirect_uris.add_error Rex.t(:"operation.error.redirect_uris_required")
      end
    end

    private def validate_redirect_uris_valid
      redirect_uris.value.try do |value|
        return unless value.any? do |uri|
          uri.includes?('#') || URI.parse(uri).scheme.nil?
        end

        return redirect_uris.add_error Rex.t(
          :"operation.error.redirect_uris_invalid",
          redirect_uris: value.join(", ")
        )
      end
    end

    private def validate_user_id_required
      validate_required user_id,
        message: Rex.t(:"operation.error.user_id_required")
    end

    private def validate_user_exists
      return unless user_id.changed?

      validate_foreign_key user_id,
        query: UserQuery,
        message: Rex.t(
          :"operation.error.user_not_found",
          user_id: user_id.value
        )
    end

    private def ensure_redirect_uris_unique
      redirect_uris.value = redirect_uris.value.try(&.uniq)
    end

    private def limit_redirect_uris_count
      redirect_uris.value.try do |value|
        redirect_uris.value =
          value.first(Shield.settings.oauth_client_redirect_uris_max)
      end
    end
  end
end
