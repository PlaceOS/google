require "./attendee"
require "./g_time"
require "./attachment"

module Google
  class Calendar
    class EntryPoint
      include JSON::Serializable

      @[JSON::Field(key: "entryPointType")]
      property type : String
      property uri : String
      property label : String?
      property pin : String?

      @[JSON::Field(key: "accessCode")]
      property access_code : String?

      @[JSON::Field(key: "meetingCode")]
      property meeting_code : String?
      property passcode : String?
      property password : String?

      def security
        pin || access_code || meeting_code || passcode || password
      end
    end

    class ConferenceSolution
      include JSON::Serializable
      include JSON::Serializable::Unmapped

      property name : String
    end

    class ConferenceData
      include JSON::Serializable
      include JSON::Serializable::Unmapped

      @[JSON::Field(key: "conferenceId")]
      property conference_id : String?

      @[JSON::Field(key: "entryPoints")]
      property entry_points : Array(EntryPoint)?

      @[JSON::Field(key: "conferenceSolution")]
      property conference_solution : ConferenceSolution?
    end

    class Event
      include JSON::Serializable

      property kind : String
      property etag : String
      property id : String
      property status : String?

      @[JSON::Field(key: "htmlLink")]
      property html_link : String

      @[JSON::Field(converter: Google::RFC3339Converter)]
      property created : Time?

      @[JSON::Field(converter: Google::RFC3339Converter)]
      property updated : Time

      property summary : String?
      property description : String?
      property location : String?

      @[JSON::Field(key: "colorId")]
      property color_id : String?
      property creator : Calendar::Attendee?
      property organizer : Calendar::Attendee?
      property start : Calendar::GTime
      property end : Calendar::GTime?

      @[JSON::Field(key: "endTimeUnspecified")]
      property end_time_unspecified : Bool?
      property recurrence : Array(String)?

      @[JSON::Field(key: "recurringEventId")]
      property recurring_event_id : String?

      @[JSON::Field(key: "originalStartTime")]
      property original_start_time : Calendar::GTime?
      property transparency : String?
      property visibility : String?

      @[JSON::Field(key: "iCalUID")]
      property ical_uid : String
      property sequence : Int64?
      property attendees : Array(Calendar::Attendee)?

      @[JSON::Field(key: "attendeesOmitted")]
      property attendees_omitted : Bool?

      @[JSON::Field(key: "extendedProperties")]
      property extended_properties : Hash(String, Hash(String, String))?

      @[JSON::Field(key: "hangoutLink")]
      property hangout_link : String?

      @[JSON::Field(key: "anyoneCanAddSelf")]
      property anyone_can_add_self : Bool?

      @[JSON::Field(key: "guestsCanInviteOthers")]
      property guests_can_invite_others : Bool?

      @[JSON::Field(key: "guestsCanModify")]
      property guests_can_modify : Bool?

      @[JSON::Field(key: "guestsCanSeeOtherGuests")]
      property guests_can_see_other_guests : Bool?

      @[JSON::Field(key: "privateCopy")]
      property private_copy : Bool?
      property locked : Bool?

      @[JSON::Field(key: "conferenceData")]
      property conference_data : ConferenceData?

      property attachments : Array(Attachment) = [] of Google::Calendar::Attachment

      def online_meeting_url
        return @hangout_link if @hangout_link
        if video = @conference_data.try &.entry_points.find { |point| point.type == "video" }
          {video.uri, video.security}
        end
      end

      def online_meeting_phones
        numbers = [] of Tuple(String, String?)
        @conference_data.try &.entry_points.each do |point|
          next unless point.type == "phone"
          # point URI starts with `tel:`
          numbers << {point.uri[4..-1], point.security}
        end
        numbers
      end

      def online_meeting_sip
        if sip = @conference_data.try &.entry_points.find { |point| point.type == "sip" }
          {sip.uri[4..-1], sip.security}
        end
      end

      def online_meeting_id
        @conference_data.try &.conference_id
      end

      def online_meeting_provider
        @conference_data.try &.conference_solution.try &.name
      end
    end
  end
end
