module Google
  class Calendar
    class ListEntry
      include JSON::Serializable

      property kind : String
      property etag : String
      property id : String

      @[JSON::Field(key: "summary")]
      property summaryMain : String
      property description : String?
      property location : String?
      property timeZone : String?
      property summaryOverride : String?
      property colorId : String?
      property backgroundColor : String?
      property foregroundColor : String?
      property accessRole : String?

      property hidden : Bool?
      property selected : Bool?
      property primary : Bool?
      property deleted : Bool?

      def summary : String
        summaryOverride || summaryMain
      end
    end

    class List
      include JSON::Serializable

      property kind : String
      property etag : String
      property nextPageToken : String?
      property nextSyncToken : String

      property items : Array(Calendar::ListEntry)
    end
  end
end
