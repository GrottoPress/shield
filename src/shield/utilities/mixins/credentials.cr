module Shield::Credentials
  macro included
    getter :id
    getter password : String

    def to_json(json)
      json.string(to_s)
    end

    def to_s(io)
      io << Base64.urlsafe_encode("#{id}:#{password}", false)
    end

    def self.from_token(token) : self
      from_token?(token).not_nil!
    end

    def self.from_token?(token : String) : self?
      decoded = Base64.decode_string(token)
      id, _, password = decoded.partition(':')
      return if password.empty?

      \{{ @type.instance_vars.find(&.name.== "id".id).type }}.adapter
        .parse(id)
        .value.try do |id|

        new(password, id)
      end
    rescue Base64::Error
    end
  end
end
