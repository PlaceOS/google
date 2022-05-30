require "./user"

module Google
  class FirebaseAuth
    class LookupUserResponse
      include JSON::Serializable

      property kind : String
      property users : Array(User)?

      def users : Array(User)
        @users || [] of User
      end
    end
  end
end
