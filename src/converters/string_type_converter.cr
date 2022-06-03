module Google
  # Converter for stringly typed values
  module StringTypeConverter(T)
    def self.from_json(json : JSON::PullParser) : T
      T.new(json.read_string)
    end

    def self.to_json(value : T, json : JSON::Builder)
      json.string(value.to_s)
    end
  end
end
