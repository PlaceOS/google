module Google
  class Calendar
    class AvailabilityStatus
      include JSON::Serializable

      property status : String
      property starts_at : Calendar::GTime
      property ends_at : Calendar::GTime

      def initialize(@status, @starts_at, @ends_at)
      end
    end

    class CalendarAvailability
      include JSON::Serializable

      property calendar : String
      property availability : Array(AvailabilityStatus)

      def initialize(@calendar, @availability)
      end
    end

    class Availability
      include JSON::Serializable

      property value : Array(CalendarAvailability)

      def initialize(@value)
      end

      def self.parse_json(data)
        result = [] of CalendarAvailability
        JSON.parse(data)["calendars"].as_h.each do |calendar, busy_data|
          availability = busy_data["busy"].as_a.map do |fb|
            AvailabilityStatus.new(status: "busy",
              starts_at: GTime.new(Time.parse_rfc3339(fb["start"].as_s)),
              ends_at: GTime.new(Time.parse_rfc3339(fb["end"].as_s)))
          end
          result << CalendarAvailability.new(calendar: calendar, availability: availability)
        end
        Calendar::Availability.new(value: result)
      end
    end
  end
end
