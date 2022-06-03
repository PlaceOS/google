require "./user"

module Google
  class FirebaseAuth
    class LookupUserResponse
      include JSON::Serializable

      getter kind : String?
      getter users : Array(User) { [] of User }
    end
  end
end
