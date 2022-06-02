require "./user"

module Google
  class FirebaseAuth
    class DeleteUserResponse
      include JSON::Serializable

      property kind : String?
    end
  end
end
