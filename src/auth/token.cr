module Google
  class Token
    include JSON::Serializable

    property access_token : String
    property expires_in : Int32
    property token_type : String
    property expires : Time = Time.utc

    def expired?
      Time.utc >= @expires
    end

    def current?
      Time.utc < @expires
    end
  end
end
