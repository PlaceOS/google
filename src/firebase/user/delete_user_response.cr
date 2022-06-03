require "./user"

module Google
  class FirebaseAuth
    class DeleteUserResponse
      include JSON::Serializable

      getter kind : String?
    end
  end
end
