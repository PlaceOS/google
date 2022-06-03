require "./user"

module Google
  class FirebaseAuth
    class BatchUserResponse
      include JSON::Serializable

      getter kind : String?
      getter users : Array(User) { [] of User }

      @[JSON::Field(key: "nextPageToken")]
      getter next_page_token : String?
    end
  end
end
