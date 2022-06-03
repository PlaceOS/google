require "../firebase_int64_converter"
require "./user"

module Google
  class FirebaseAuth
    class QueryUserResponse
      include JSON::Serializable

      @[JSON::Field(key: "recordsCount", converter: Google::FirebaseAuth::Int64Converter)]
      getter records_count : Int64

      @[JSON::Field(key: "userInfo")]
      getter users : Array(User) { [] of User }
    end
  end
end
