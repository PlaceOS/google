require "./group"

module Google
  class Directory
    class GroupQuery
      include JSON::Serializable

      property kind : String
      property etag : String?

      property groups : Array(Group)?

      @[JSON::Field(key: "nextPageToken")]
      property next_page_token : String?

      def groups : Array(Group)
        @groups || [] of Group
      end
    end
  end
end
