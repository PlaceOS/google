module Google
  class Directory
    class Group
      include JSON::Serializable

      property kind : String
      property id : String
      property etag : String?

      property email : String
      property name : String?
      property description : String?

      @[JSON::Field(key: "directMembersCount")]
      property direct_members_count : Int32

      @[JSON::Field(key: "adminCreated")]
      property admin_created : Bool?

      @[JSON::Field(key: "nonEditableAliases")]
      property non_editable_aliases : Array(String)?
      property aliases : Array(String)?

      def aliases
        @aliases || [] of String
      end

      def non_editable_aliases
        @non_editable_aliases || [] of String
      end
    end
  end
end
