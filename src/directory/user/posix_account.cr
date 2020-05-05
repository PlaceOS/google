module Google
  class Directory
    class User
      # https://developers.google.com/admin-sdk/directory/v1/reference/users#resource
      class PosixAccount
        include JSON::Serializable

        @[JSON::Field(key: "accountId")]
        property account_id : String?
        # https://en.wikipedia.org/wiki/Gecos_field
        property gecos : String?
        property gid : UInt64?

        @[JSON::Field(key: "homeDirectory")]
        property home_directory : String?

        @[JSON::Field(key: "operatingSystemType")]
        property operating_system_type : String?
        property primary : Bool?
        property shell : String?

        @[JSON::Field(key: "systemId")]
        property system_id : String?
        property uid : UInt64?
        property username : String?
      end
    end
  end
end
