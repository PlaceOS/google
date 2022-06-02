require "./calendar/calendar"
require "./calendar/batch_request"
require "./directory/directory"
require "./files/files"
require "./translate/translate"
require "./passes/event_tickets"
require "./gmail/messages"
require "./firebase/firebase_auth"

module Google
  Log               = ::Log.for("google")
  GOOGLE_URI        = URI.parse("https://www.googleapis.com")
  FIREBASE_AUTH_URI = URI.parse("https://identitytoolkit.googleapis.com")

  class Exception < ::Exception
    property http_status : HTTP::Status
    property http_body : String

    def initialize(@http_status, @http_body, @message = nil)
    end

    def self.raise_on_failure(response)
      unless response.success?
        raise new(response.status, response.body, "#{response.status.description}\n#{response.body}")
      end
    end
  end
end
