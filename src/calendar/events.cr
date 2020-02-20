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

      property timeZone : String
      property accessRole : String
      property nextPageToken : String?
      property nextSyncToken : String
      property items : Array(Calendar::Event)
    end
  end
end
