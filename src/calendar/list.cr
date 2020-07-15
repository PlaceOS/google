module Google
  class Calendar
    class ListEntry
      include JSON::Serializable

      property kind : String
      property etag : String
      property id : String

      @[JSON::Field(key: "summary")]
      property summary_main : String
      property description : String?
      property location : String?

      @[JSON::Field(key: "timeZone")]
      property time_zone : String?

      @[JSON::Field(key: "summaryOverride")]
      property summary_override : String?

      @[JSON::Field(key: "colorId")]
      property color_id : String?

      @[JSON::Field(key: "backgroundColor")]
      property background_color : String?

      @[JSON::Field(key: "foregroundColor")]
      property foreground_color : String?

      @[JSON::Field(key: "accessRole")]
      property access_role : String?

      property hidden : Bool?
      property selected : Bool?
      property primary : Bool?
      property deleted : Bool?

      def summary : String
        summary_override || summary_main
      end
    end

    class List
      include JSON::Serializable

      property kind : String
      property etag : String

      @[JSON::Field(key: "nextPageToken")]
      property next_page_token : String?

      @[JSON::Field(key: "nextSyncToken")]
      property next_sync_token : String?

      property items : Array(Calendar::ListEntry)
    end
  end
end
