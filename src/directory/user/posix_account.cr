module Google
  class Directory
    class User
      # https://developers.google.com/admin-sdk/directory/v1/reference/users#resource
      class PosixAccount
        include JSON::Serializable

        property accountId : String?
        # https://en.wikipedia.org/wiki/Gecos_field
        property gecos : String?
        property gid : UInt64?
        property homeDirectory : String?
        property operatingSystemType : String?
        property primary : Bool?
        property shell : String?
        property systemId : String?
        property uid : UInt64?
        property username : String?
      end
    end
  end
end
