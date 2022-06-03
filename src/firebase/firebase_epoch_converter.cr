module Google
  class FirebaseAuth
    module EpochConverter
      def self.from_json(value : JSON::PullParser) : Time
        Time.unix(value.read_string.to_i64)
      end

      def self.to_json(value : Time, json : JSON::Builder) : Nil
        json.string(value.to_unix.to_s)
      end
    end
  end
end
