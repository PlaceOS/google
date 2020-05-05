module Google
  class Location
    include JSON::Serializable

    property type : String

    @[JSON::Field(key: "customType")]
    property custom_type : String?
    property area : String?

    @[JSON::Field(key: "buildingId")]
    property building_id : String?

    @[JSON::Field(key: "floorName")]
    property floor_name : String?

    @[JSON::Field(key: "floorSection")]
    property floor_section : String?

    @[JSON::Field(key: "deskCode")]
    property desk_code : String?
  end
end
