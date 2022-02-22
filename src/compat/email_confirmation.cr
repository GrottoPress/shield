module Shield::Api::EmailConfirmations::Edit
  macro included
    {% puts "Warning: Deprecated `Shield::Api::EmailConfirmations::Edit`. \
      Use `Shield::Api::EmailConfirmations::Update` instead" %}

    include Shield::Api::EmailConfirmations::Update
  end
end

module Shield::EmailConfirmations::Edit
  macro included
    {% puts "Warning: Deprecated `Shield::EmailConfirmations::Edit`. \
      Use `Shield::EmailConfirmations::Update` instead" %}

    include Shield::EmailConfirmations::Update
  end
end
