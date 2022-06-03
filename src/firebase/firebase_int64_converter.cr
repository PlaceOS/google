module Google
  class FirebaseAuth
    module Int64Converter
      def self.from_json(value : JSON::PullParser) : Int64
        value.read_string.to_i64
      end

      def self.to_json(value : Int64, json : JSON::Builder) : Nil
        json.string(value.to_s)
      end
    end
  end
end
