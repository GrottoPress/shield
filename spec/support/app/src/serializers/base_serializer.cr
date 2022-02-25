abstract struct BaseSerializer
  include Lucille::Serializer

  def self.for_collection(collection : Enumerable, *args, **named_args)
    collection.map { |object| new(object, *args, **named_args) }
  end
end
