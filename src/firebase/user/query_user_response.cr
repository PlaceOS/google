require "./user"

module Google
  class FirebaseAuth
    class QueryUserResponse
      include JSON::Serializable

      @[JSON::Field(key: "recordsCount")]
      property records_count : String # Int64

      @[JSON::Field(key: "userInfo")]
      property users : Array(User)?

      def users : Array(User)
        @users || [] of User
      end
    end
  end
end
