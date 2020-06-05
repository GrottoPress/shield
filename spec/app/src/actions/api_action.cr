abstract class ApiAction < Lucky::Action
  include Shield::Action

  accepted_formats [:json]
end
