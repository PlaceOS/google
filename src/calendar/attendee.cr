module Google
  class Calendar
    class Attendee
      include JSON::Serializable

      property id : String?
      property email : String
      property displayName : String?
      property organizer : Bool?
      property self : Bool?
      property resource : Bool?
      property optional : Bool?
      property responseStatus : String?
      property comment : String?
      property additionalGuests : Int32?
    end
  end
end
