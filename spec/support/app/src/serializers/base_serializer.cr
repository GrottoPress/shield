abstract struct BaseSerializer
  include Lucille::Serializer

  def self.list(list : Array, *args, **named_args)
    list.map { |object| new(object, *args, **named_args) }
  end
end
