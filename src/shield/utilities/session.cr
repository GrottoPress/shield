module Shield::Session
  macro included
    def initialize(@session : Lucky::Session)
    end

    abstract def delete : self

    abstract def set(*values) : self
  end
end
