require "./group"

module Google
  class Directory
    class GroupQuery
      include JSON::Serializable

      property kind : String
      property etag : String?

      property groups : Array(Group) { [] of Group }

      @[JSON::Field(key: "nextPageToken")]
      property next_page_token : String?
    end
  end
end
