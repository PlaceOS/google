module Google
  class Calendar
    class GTime
      include JSON::Serializable

      def initialize(datetime : Time, all_day = false)
        tz = datetime.location.name
        # ignore special cases
        @time_zone = {"Local", ""}.includes?(tz) ? nil : tz

        if all_day
          @date = datetime
        else
          @date_time = datetime
        end
      end

      def time : Time
        if dtime = @date_time
          dtime
        elsif dday = @date
          dday
        else
          raise "no time provided?"
        end
      end

      # %F: ISO 8601 date (2016-04-05)
      @[JSON::Field(converter: ::Time::Format.new("%F"), emit_null: true)]
      property date : Time?

      @[JSON::Field(emit_null: true, key: "dateTime")]
      property date_time : Time?

      @[JSON::Field(key: "timeZone")]
      property time_zone : String?
    end
  end
end
