module Google
  module EpochMillisConverter
    def self.from_json(value : JSON::PullParser) : Time
      Time.unix_ms(value.read_string.to_i64)
    end

    def self.to_json(value : Time, json : JSON::Builder) : Nil
      json.string(value.to_unix_ms.to_s)
    end
  end
end
