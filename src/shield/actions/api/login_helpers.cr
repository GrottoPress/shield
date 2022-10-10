module Shield::Api::LoginHelpers
  macro included
    include Shield::LoginHelpers

    getter? current_login : Login? do
      LoginHeaders.new(context.request).verify
    end
  end
end
