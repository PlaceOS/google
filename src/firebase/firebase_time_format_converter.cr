module Google
  class FirebaseAuth
    module TimeFormatConverter
      def self.from_json(value : JSON::PullParser) : Time
        Time::Format::RFC_3339.parse(value.read_string)
      end

      def self.to_json(value : Time, json : JSON::Builder) : Nil
        json.string(Time::Format::RFC_3339.format(value))
      end
    end
  end
end
