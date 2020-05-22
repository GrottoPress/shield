module Shield::Model
  macro included
    include Shield::Authorization

    macro finished
      create_default_table
    end

    macro inherited
      macro finished
        create_default_table
      end
    end

    private macro create_default_table
      \{% if ! @type.constant(:TABLE_NAME) %}
        table {}
      \{% end %}
    end
  end
end
