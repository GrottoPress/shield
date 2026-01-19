{% skip_file unless Avram::Model.all_subclasses
  .any?(&.name.== :UserOptions.id)
%}

require "./common"

class UserOptionsQuery < UserOptions::BaseQuery
  include Shield::UserOptionsQuery
end

class SaveUserOptions < UserOptions::SaveOperation
  include Shield::SaveUserOptions
end
