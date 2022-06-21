module Google
  class Calendar
    class Notification
      include JSON::Serializable

      property id : String
      property type : String = "web_hook"
      property address : String
      property token : String?
      property expiration : Int64?

      def initialize(@id, @address, @token = nil, expiration : Time? = nil)
        @expiration = expiration.try(&.to_unix_ms)
      end

      struct Receipt
        include JSON::Serializable

        getter kind : String
        getter id : String

        # required for deleting this notification
        @[JSON::Field(key: "resourceId")]
        getter resource_id : String

        @[JSON::Field(key: "resourceUri")]
        getter resource_uri : String
        getter token : String?
        getter expiration : Int64?
      end
    end
  end
end
