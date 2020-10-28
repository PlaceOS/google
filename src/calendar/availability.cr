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
      property error : String?

      def initialize(@calendar, @availability, @error = nil)
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
          if errors = busy_data["errors"]?
            availability = [] of AvailabilityStatus
            error = errors[0]["reason"].as_s
          else
            error = nil
            availability = busy_data["busy"].as_a.map do |fb|
              AvailabilityStatus.new(status: "busy",
                starts_at: GTime.new(Time.parse_rfc3339(fb["start"].as_s)),
                ends_at: GTime.new(Time.parse_rfc3339(fb["end"].as_s)))
            end
          end
          result << CalendarAvailability.new(calendar: calendar, availability: availability, error: error)
        end
        Calendar::Availability.new(value: result)
      end
    end
  end
end
