module Google
  class Token
    include JSON::Serializable

    property access_token : String
    property expires_in : Int32
    property token_type : String
    property expires : Time = Time.utc
    property refresh_token : String? = nil

    def expired?
      Time.utc >= @expires
    end

    def current?
      Time.utc < @expires
    end

    def initialize(@access_token, @expires, @refresh_token)
      @token_type = ""
      @expires_in = 0
    end
  end
end
