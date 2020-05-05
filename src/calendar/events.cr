module Google
  class Calendar
    class Events
      include JSON::Serializable

      property kind : String
      property etag : String
      property summary : String
      property description : String?

      @[JSON::Field(converter: Google::RFC3339Converter)]
      property updated : ::Time

      @[JSON::Field(key: "timeZone")]
      property time_zone : String

      @[JSON::Field(key: "accessRole")]
      property access_role : String

      @[JSON::Field(key: "nextPageToken")]
      property next_page_token : String?

      @[JSON::Field(key: "nextSyncToken")]
      property next_sync_token : String
      property items : Array(Calendar::Event)
    end
  end
end
