require "../firebase_string_type_converter"
require "./user"

module Google
  class FirebaseAuth
    class QueryUserResponse
      include JSON::Serializable

      @[JSON::Field(key: "recordsCount", converter: Google::FirebaseAuth::StringTypeConverter(Int64))]
      getter records_count : Int64

      @[JSON::Field(key: "userInfo")]
      getter users : Array(User) { [] of User }
    end
  end
end
