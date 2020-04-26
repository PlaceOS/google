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
      property primaryEmail : String
      property isAdmin : Bool
      property isDelegatedAdmin : Bool
      property lastLoginTime : Time?
      property creationTime : Time
      property deletionTime : Time?
      property agreedToTerms : Bool
      property password : String?
      property hashFunction : String?
      property suspended : Bool

      property suspensionReason : String?
      property archived : Bool?
      property changePasswordAtNextLogin : Bool
      property ipWhitelisted : Bool

      property emails : Array(Email)
      property relations : Array(Relation)?
      property externalIds : Array(Relation)?
      property addresses : Array(Address)?
      property organizations : Array(Organization)?
      property phones : Array(Phone)?
      property languages : Array(Language)?
      property aliases : Array(String)?
      property nonEditableAliases : Array(String)?
      property notes : NamedTuple(value: String, contentType: String?)?
      property websites : Array(Phone)?
      property locations : Array(Location)?
      property keywords : Array(Relation)?
      property gender : Gender?
      property posixAccounts : Array(PosixAccount)?

      property customerId : String?
      property orgUnitPath : String?
      property isMailboxSetup : Bool
      property isEnrolledIn2Sv : Bool?
      property isEnforcedIn2Sv : Bool?
      property includeInGlobalAddressList : Bool
      property thumbnailPhotoUrl : String?
      property thumbnailPhotoEtag : String?

      property customSchemas : Hash(String, Hash(String, String))?
    end
  end
end
