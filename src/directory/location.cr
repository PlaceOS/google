module Google
  class Location
    include JSON::Serializable

    property type : String
    property customType : String?
    property area : String?
    property buildingId : String?
    property floorName : String?
    property floorSection : String?
    property deskCode : String?
  end
end
