require "./user"

module Google
  class FirebaseAuth
    class BatchUserResponse
      include JSON::Serializable

      property kind : String?
      property users : Array(User)?

      @[JSON::Field(key: "nextPageToken")]
      property next_page_token : String?

      def users : Array(User)
        @users || [] of User
      end
    end
  end
end
