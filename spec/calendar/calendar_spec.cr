require "../spec_helper"

describe Google::Calendar do
  describe "#calendar_list" do
    pending "works in case of successful api call" do
    end
  end

  describe "#events" do
    it "works in case of successful api call" do
      CalendarHelper.mock_token
      CalendarHelper.mock_events

      CalendarHelper.calendar.events.is_a?(Google::Calendar::Events).should eq(true)
    end
  end

  describe "#event" do
    it "works in case of successful api call" do
      CalendarHelper.mock_token
      CalendarHelper.mock_event

      CalendarHelper.calendar.event(123).is_a?(Google::Calendar::Event).should eq(true)
    end
  end

  describe "#create" do
    pending "works in case of successful api call" do
    end
  end

  describe "#update" do
    pending "works in case of successful api call" do
    end
  end

  describe "#delete" do
    pending "works in case of successful api call" do
    end
  end

  describe "#move" do
    pending "works in case of successful api call" do
    end
  end
end

module CalendarHelper
  extend self

  def mock_token
    WebMock.stub(:post, "https://www.googleapis.com/oauth2/v4/token")
      .to_return(body: {access_token: "test_token", expires_in: 3599, token_type: "Bearer"}.to_json)
  end

  def mock_events
    WebMock.stub(:get, "https://www.googleapis.com/calendar/v3/calendars/primary/events?maxResults=2500&singleEvents=true&timeMin=2020-02-19T13:00:00Z")
      .to_return(body: events_response.to_json)
  end

  def events_response
    {
      "kind":          "hi",
      "etag":          "12121",
      "summary":       "example summar",
      "updated":       Time.utc,
      "timeZone":      "Local",
      "accessRole":    "User",
      "nextSyncToken": "TOKEN123",
      "items":         [event_response],
    }
  end

  def mock_event
    WebMock.stub(:get, "https://www.googleapis.com/calendar/v3/calendars/primary/events/123").
      to_return(body: event_response.to_json)
  end

  def event_response
    {
      "kind":     "test",
      "etag":     "12121",
      "id":       "123456789",
      "iCalUID":  "123456789",
      "htmlLink": "https://example.com",
      "updated":  Time.utc,
      "start":    {"dateTime": Time.utc},
      "creator":  {
        "email": "test@example.com",
      },
    }
  end

  def calendar
    Google::Calendar.new(auth: auth)
  end

  def auth
    Google::FileAuth.new(file_path: client_auth_file, scopes: "TEST_GOOGLE_API_SCOPE")
  end

  def client_auth_file
    File.expand_path("./spec/fixtures/client_auth.json")
  end
end
