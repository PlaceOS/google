module Google
  module TimeSpanConverter
    def self.from_json(value : JSON::PullParser) : Time::Span
      Time::Span.new(seconds: value.read_string.to_i64)
    end

    def self.to_json(value : Time::Span, json : JSON::Builder) : Nil
      json.string(value.total_seconds.to_i64.to_s)
    end
  end
end
