require "./user"

module Google
  class FirebaseAuth
    # API details: https://cloud.google.com/identity-platform/docs/reference/rest/v1/QueryUserInfoResponse
    class QueryUserResponse
      include JSON::Serializable

      @[JSON::Field(key: "recordsCount", converter: Google::StringTypeConverter(Int64))]
      getter records_count : Int64

      @[JSON::Field(key: "userInfo")]
      getter users : Array(User) { [] of User }
    end
  end
end
