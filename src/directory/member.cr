module Google
  class Directory
    class Member
      include JSON::Serializable

      property kind : String
      property email : String
      property role : String?
      property etag : String
      property type : String
      property status : String
      property delivery_settings : String?
      property id : String
    end

    class MemberQuery
      include JSON::Serializable

      property kind : String
      property members : Array(Member) { [] of Member }

      @[JSON::Field(key: "nextPageToken")]
      property next_page_token : String?
    end
  end
end
