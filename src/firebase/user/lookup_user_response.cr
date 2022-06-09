require "./user"

module Google
  class FirebaseAuth

    # API details: https://cloud.google.com/identity-platform/docs/reference/rest/v1/GetAccountInfoResponse
    class LookupUserResponse
      include JSON::Serializable

      getter kind : String?
      getter users : Array(User) { [] of User }
    end
  end
end
