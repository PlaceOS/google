require "./attendee"
require "./g_time"

module Google
  class CalendarEvent
    include JSON::Serializable

    property kind : String
    property etag : String
    property id : String
    property status : String?
    property htmlLink : String

    @[JSON::Field(converter: Google::RFC3339Converter)]
    property created : Time?

    @[JSON::Field(converter: Google::RFC3339Converter)]
    property updated : Time

    property summary : String?
    property description : String?
    property location : String?
    property colorId : String?
    property creator : Attendee
    property organizer : Attendee?
    property start : GTime
    property end : GTime?
    property endTimeUnspecified : Bool?
    property recurrence : Array(String)?
    property recurringEventId : String?
    property originalStartTime : GTime?
    property transparency : String?
    property visibility : String?
    property iCalUID : String
    property sequence : Int64?
    property attendees : Array(Attendee)?
    property attendeesOmitted : Bool?
    property extendedProperties : Hash(String, Hash(String, String))?
    property hangoutLink : String?
    property anyoneCanAddSelf : Bool?
    property guestsCanInviteOthers : Bool?
    property guestsCanModify : Bool?
    property guestsCanSeeOtherGuests : Bool?
    property privateCopy : Bool?
    property locked : Bool?
  end
end
