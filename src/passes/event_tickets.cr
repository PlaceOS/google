require "connect-proxy"
require "jwt"
require "uri"
require "uuid"
require "../auth/file_auth"
require "./models/*"

module Google
  class EventTickets
    WALLET_OBJECTS_BASE_URI = URI.parse("https://walletobjects.googleapis.com")

    property ticket_class_id : String
    property ticket_object_id : String
    property auth : Google::FileAuth
    property issuer_name : String
    property event_name : String
    property ticket_holder_name : String
    property qr_code_value : String
    property qr_code_alternate_text : String?
    property origins : Array(String)
    property location : NamedTuple(lat: Float64, lon: Float64)
    property event_details : NamedTuple(header: String?, body: String?)?
    property date_time : NamedTuple(start: String, end: String)?
    property logo_image : NamedTuple(uri: String?, description: String?)?
    property event_image : NamedTuple(uri: String?, description: String?)?
    property venue : NamedTuple(name: String?, address: String?)?

    def initialize(auth : Google::Auth | Google::FileAuth | String,
                   issuer_id : String,
                   serial_number : String,
                   @issuer_name,
                   @event_name,
                   @ticket_holder_name,
                   @qr_code_value,
                   @location,
                   @qr_code_alternate_text = nil,
                   @origins = [] of String,
                   @event_details = nil,
                   @date_time = nil,
                   @logo_image = nil,
                   @event_image = nil,
                   @venue = nil,
                   user_agent : String? = nil)
      @ticket_class_id = "#{issuer_id}.#{serial_number}-class"
      @ticket_object_id = "#{issuer_id}.#{serial_number}-object"

      @auth = auth
      # If user agent not provided, then use the auth.user_agent
      # if a token was passed in directly then use the default agent string
      agent = user_agent || case auth
      in Google::Auth, Google::FileAuth
        auth.user_agent
      in String
        Google::Auth::DEFAULT_USER_AGENT
      end
      @user_agent = agent
    end

    @user_agent : String

    def execute
      create_class
      create_object
      get_pass_url
    end

    private def create_class
      body = ticket_class_payload.to_json
      response = ConnectProxy::HTTPClient.new(WALLET_OBJECTS_BASE_URI) do |client|
        client.exec(
          "POST",
          "/walletobjects/v1/eventTicketClass",
          HTTP::Headers{
            "Authorization" => "Bearer #{get_token}",
            "Content-Type"  => "application/json",
            "User-Agent"    => @user_agent,
          },
          body
        )
      end
      Google::Exception.raise_on_failure(response)
    end

    private def create_object
      body = ticket_object_payload.to_json
      response = ConnectProxy::HTTPClient.new(WALLET_OBJECTS_BASE_URI) do |client|
        client.exec(
          "POST",
          "/walletobjects/v1/eventTicketObject",
          HTTP::Headers{
            "Authorization" => "Bearer #{get_token}",
            "Content-Type"  => "application/json",
            "User-Agent"    => @user_agent,
          },
          body
        )
      end
      Google::Exception.raise_on_failure(response)
    end

    private def get_pass_url
      "https://pay.google.com/gp/v/save/#{generate_pass_jwt}"
    end

    private def ticket_class_payload
      Google::EventTicketClass.new(ticket_class_id,
        issuer_name,
        event_name: event_name,
        location: location,
        event_details: event_details,
        date_time: date_time,
        logo_image: logo_image,
        event_image: event_image,
        venue: venue
      )
    end

    private def ticket_object_payload
      Google::EventTicketObject.new(id: ticket_object_id,
        class_id: ticket_class_id,
        ticket_holder_name: ticket_holder_name,
        qr_code_value: qr_code_value,
        qr_code_alternate_text: qr_code_alternate_text)
    end

    private def pass_jwt_body
      {
        "iss":     auth.client_email,
        "aud":     "google",
        "typ":     "savetoandroidpay",
        "iat":     Time.utc.to_unix,
        "payload": {
          "webserviceResponse": {
            "result":  "approved",
            "message": "Success.",
          },
          "eventTicketObjects": [{id: ticket_object_id}],
        },
        "origins": origins,
      }
    end

    private def get_token : String
      auth = @auth
      case auth
      in Google::Auth, Google::FileAuth
        auth.get_token.access_token
      in String
        auth
      end
    end

    private def generate_pass_jwt
      JWT.encode(
        payload: pass_jwt_body,
        key: auth.signing_key,
        algorithm: JWT::Algorithm::RS256,
      )
    end
  end
end
