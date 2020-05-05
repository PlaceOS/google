require "./address"
require "./email"
require "./gender"
require "./language"
require "./name"
require "./organization"
require "./phone"
require "./relation"
require "./posix_account"

module Google
  class Directory
    class User
      include JSON::Serializable

      property name : Name

      # Optional for creating a user
      property kind : String?
      property id : String?
      property etag : String?

      @[JSON::Field(key: "primaryEmail")]
      property primary_email : String

      @[JSON::Field(key: "isAdmin")]
      property is_admin : Bool

      @[JSON::Field(key: "isDelegatedAdmin")]
      property is_delegated_admin : Bool

      @[JSON::Field(key: "lastLoginTime")]
      property last_login_time : Time?

      @[JSON::Field(key: "creationTime")]
      property creation_time : Time

      @[JSON::Field(key: "deletionTime")]
      property deletion_time : Time?

      @[JSON::Field(key: "agreedToTerms")]
      property agreed_to_terms : Bool
      property password : String?

      @[JSON::Field(key: "hashFunction")]
      property hash_function : String?
      property suspended : Bool

      @[JSON::Field(key: "suspensionReason")]
      property suspension_reason : String?
      property archived : Bool?

      @[JSON::Field(key: "changePasswordAtNextLogin")]
      property change_password_at_next_login : Bool

      @[JSON::Field(key: "ipWhitelisted")]
      property ip_whitelisted : Bool

      property emails : Array(Email)
      property relations : Array(Relation)?

      @[JSON::Field(key: "externalIds")]
      property external_ids : Array(Relation)?
      property addresses : Array(Address)?
      property organizations : Array(Organization)?
      property phones : Array(Phone)?
      property languages : Array(Language)?
      property aliases : Array(String)?

      @[JSON::Field(key: "nonEditableAliases")]
      property non_editable_aliases : Array(String)?
      property notes : NamedTuple(value: String, contentType: String?)?
      property websites : Array(Phone)?
      property locations : Array(Location)?
      property keywords : Array(Relation)?
      property gender : Gender?

      @[JSON::Field(key: "posixAccounts")]
      property posix_accounts : Array(PosixAccount)?

      @[JSON::Field(key: "customerId")]
      property customer_id : String?

      @[JSON::Field(key: "orgUnitPath")]
      property org_unit_path : String?

      @[JSON::Field(key: "isMailboxSetup")]
      property is_mailbox_setup : Bool

      @[JSON::Field(key: "isEnrolledIn2Sv")]
      property is_enrolled_in_2sv : Bool?

      @[JSON::Field(key: "isEnforcedIn2Sv")]
      property is_enforced_in_2sv : Bool?

      @[JSON::Field(key: "includeInGlobalAddressList")]
      property include_in_global_address_list : Bool

      @[JSON::Field(key: "thumbnailPhotoUrl")]
      property thumbnail_photo_url : String?

      @[JSON::Field(key: "thumbnailPhotoEtag")]
      property thumbnail_photo_etag : String?

      @[JSON::Field(key: "recovery_phone")]
      property recovery_phone : String?

      @[JSON::Field(key: "customSchemas")]
      property custom_schemas : Hash(String, Hash(String, String))?
    end
  end
end
