module Google
  class Directory
    class UserQuery
      include JSON::Serializable

      property kind : String
      property users : Array(User)
      property nextPageToken : String?
    end
  end
end
