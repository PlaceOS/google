module Google
  class EventTicketClass
    include JSON::Serializable

    property id : String

    @[JSON::Field(key: "issuerName")]
    property issuer_name : String

    @[JSON::Field(key: "eventName")]
    property event_name : EventName

    @[JSON::Field(key: "reviewStatus")]
    property review_status : String = "underReview"

    property locations : Array(Location)

    @[JSON::Field(key: "textModulesData")]
    property text_modules_data : Array(TextModule)?

    @[JSON::Field(key: "dateTime")]
    property date_time : DateTime?

    @[JSON::Field(key: "imageModulesData")]
    property image_modules_data : Array(MainImage)?

    property logo : ImageModule? = nil

    property venue : Venue? = nil

    def initialize(@id,
                   @issuer_name,
                   event_name : String,
                   location : NamedTuple(lat: Float64, lon: Float64),
                   event_details : NamedTuple(header: String?, body: String?)? = nil,
                   date_time : NamedTuple(start: String, end: String)? = nil,
                   logo_image : NamedTuple(uri: String?, description: String?)? = nil,
                   event_image : NamedTuple(uri: String?, description: String?)? = nil,
                   venue : NamedTuple(name: String?, address: String?)? = nil)
      @event_name = EventName.new(value: event_name)
      @locations = [Location.new(latitude: location[:lat], longitude: location[:lon])]
      if event_details
        @text_modules_data = [TextModule.new(header: event_details[:header], body: event_details[:body])]
      end
      if date_time
        @date_time = DateTime.new(start: date_time[:start], end: date_time[:end])
      end
      if logo_image
        @logo = ImageModule.new(uri: logo_image[:uri], description: logo_image[:description])
      end
      if event_image
        @image_modules_data = [MainImage.new(uri: event_image[:uri], description: event_image[:description])]
      end
      if venue
        @venue = Venue.new(name: venue[:name], address: venue[:address])
      end
    end

    struct EventName
      include JSON::Serializable

      @[JSON::Field(key: "defaultValue")]
      property default_value : DefaultValue

      def initialize(value : String)
        @default_value = DefaultValue.new(value: value)
      end

      struct DefaultValue
        include JSON::Serializable

        property language : String = "en-US"
        property value : String

        def initialize(@value)
        end
      end
    end

    struct Location
      include JSON::Serializable

      property kind : String = "walletobjects#latLongPoint"
      property latitude : Float64
      property longitude : Float64

      def initialize(@latitude, @longitude)
      end
    end

    struct TextModule
      include JSON::Serializable

      property header : String?

      property body : String?

      def initialize(@header, @body)
      end
    end

    struct MainImage
      include JSON::Serializable

      @[JSON::Field(key: "mainImage")]
      property main_image : ImageModule

      def initialize(uri : String?, description : String?)
        @main_image = ImageModule.new(uri: uri, description: description)
      end
    end

    struct ImageModule
      include JSON::Serializable

      property kind : String = "walletobjects#image"

      @[JSON::Field(key: "sourceUri")]
      property source_uri : SourceUri

      def initialize(uri : String?, description : String?)
        @source_uri = SourceUri.new(uri: uri, description: description)
      end

      struct SourceUri
        include JSON::Serializable

        property uri : String?
        property description : String?

        def initialize(@uri, @description)
        end
      end
    end

    struct DateTime
      include JSON::Serializable

      property kind : String = "walletobjects#eventDateTime"
      property start : String
      property end : String

      def initialize(@start, @end)
      end
    end

    struct Venue
      include JSON::Serializable

      property name : LocalizedString?
      property address : LocalizedString?

      def initialize(name : String?, address : String?)
        @name = LocalizedString.new(value: name)
        @address = LocalizedString.new(value: address)
      end

      struct LocalizedString
        include JSON::Serializable

        property kind : String = "walletobjects#localizedString"

        @[JSON::Field(key: "defaultValue")]
        property default_value : DefaultValue

        def initialize(value : String?)
          @default_value = DefaultValue.new(value: value)
        end

        struct DefaultValue
          include JSON::Serializable

          property kind : String = "walletobjects#translatedString"
          property language : String = "en-US"
          property value : String?

          def initialize(@value)
          end
        end
      end
    end
  end
end
