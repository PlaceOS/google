module Google
  class Calendar
    class Attendee
      include JSON::Serializable

      property id : String?
      property email : String

      @[JSON::Field(key: "displayName")]
      property display_name : String?
      property organizer : Bool?
      property self : Bool?
      property resource : Bool?
      property optional : Bool?

      @[JSON::Field(key: "responseStatus")]
      property response_status : String?
      property comment : String?

      @[JSON::Field(key: "additionalGuests")]
      property additional_guests : Int32?
    end
  end
end
