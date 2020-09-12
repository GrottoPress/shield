abstract class BaseModel < Avram::Model
  include Shield::Model

  def self.database : Avram::Database.class
    AppDatabase
  end
end
