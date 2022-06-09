require "./user"

module Google
  class FirebaseAuth
    # API details: https://cloud.google.com/identity-platform/docs/reference/rest/v1/DeleteAccountResponse
    struct DeleteUserResponse
      include JSON::Serializable

      getter kind : String?
    end
  end
end
