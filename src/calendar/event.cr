require "./attendee"
require "./g_time"

module Google
  class Calendar
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
      property conference_data : JSON::Any?
    end
  end
end
