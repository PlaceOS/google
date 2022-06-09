require "./user"

module Google
  class FirebaseAuth
    # API details: https://cloud.google.com/identity-platform/docs/reference/rest/v1/DownloadAccountResponse
    struct BatchUserResponse
      include JSON::Serializable

      getter kind : String?
      getter users : Array(User) { [] of User }

      @[JSON::Field(key: "nextPageToken")]
      getter next_page_token : String?
    end
  end
end
