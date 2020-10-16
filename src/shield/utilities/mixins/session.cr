module Shield::Session
  macro included
    def initialize(@session : Lucky::Session)
    end

    def delete : self
    end

    def set(*values) : self
    end
  end
end
