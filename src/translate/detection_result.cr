module Google
  class Translate
    class DetectionResult
      include JSON::Serializable

      @[JSON::Field(key: "isReliable")]
      property? reliable : Bool

      property confidence : Int32

      property language : String
    end
  end
end
