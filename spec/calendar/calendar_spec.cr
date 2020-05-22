require "../spec_helper"

describe Google::Calendar do
  describe "#calendar_list" do
    it "works in case of successful api call" do
      CalendarHelper.mock_token
      CalendarHelper.mock_calendar_list

      cals = CalendarHelper.calendar.calendar_list
      cals.first.summary.should eq("override")
    end
  end

  describe "#events" do
    it "works in case of successful api call" do
      CalendarHelper.mock_token
      CalendarHelper.mock_events

      CalendarHelper.calendar.events(period_start: Time.utc(2016, 2, 15, 10, 20, 30)).is_a?(Google::Calendar::Events).should eq(true)
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
    it "works in case of successful api call" do
      CalendarHelper.mock_token
      CalendarHelper.mock_event_create

      CalendarHelper.calendar.create(event_start: Time.utc(2016, 2, 15, 10, 20, 30), event_end: Time.utc(2016, 2, 15, 11, 20, 30), attendees: ["test@example.com"], summary: "ACA test event", description: "test description").is_a?(Google::Calendar::Event).should eq(true)
    end
  end

  describe "#update" do
    it "works in case of successful api call" do
      CalendarHelper.mock_token
      CalendarHelper.mock_event_update

      CalendarHelper.calendar.update("123456789", summary: "updated summary").is_a?(Google::Calendar::Event).should eq(true)
    end
  end

  describe "#delete" do
    it "works in case of successful api call" do
      CalendarHelper.mock_token
      CalendarHelper.mock_event_delete

      CalendarHelper.calendar.delete("123456789").should eq(true)
    end
  end

  describe "#move" do
    it "works in case of successful api call" do
      CalendarHelper.mock_token
      CalendarHelper.mock_event_move

      CalendarHelper.calendar.move(event_id: "event_id", calendar_id: "original_calendar_id", destination_id: "destination_calendar_id").is_a?(Google::Calendar::Event).should eq(true)
    end
  end
end

module CalendarHelper
  extend self

  def mock_token
    WebMock.stub(:post, "https://www.googleapis.com/oauth2/v4/token")
      .to_return(body: {access_token: "test_token", expires_in: 3599, token_type: "Bearer"}.to_json)
  end

  def mock_calendar_list
    WebMock.stub(:get, "https://www.googleapis.com/calendar/v3/users/me/calendarList")
      .to_return(body: {
        "kind":          "calendar#calendarList",
        "etag":          "12121",
        "nextSyncToken": "TOKEN123",
        "items":         [{
          "kind":            "hi",
          "etag":            "12121",
          "id":              "123456789",
          "summary":         "example summary",
          "summaryOverride": "override",

          "hidden":   false,
          "selected": true,
          "primary":  true,
          "deleted":  false,
        }],
      }.to_json)
  end

  def mock_events
    WebMock.stub(:get, "https://www.googleapis.com/calendar/v3/calendars/primary/events?maxResults=2500&singleEvents=true&timeMin=2016-02-15T10:20:30Z")
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
    WebMock.stub(:get, "https://www.googleapis.com/calendar/v3/calendars/primary/events/123")
      .to_return(body: event_response.to_json)
  end

  def mock_event_create
    WebMock.stub(:post, "https://www.googleapis.com/calendar/v3/calendars/primary/events?conferenceDataVersion=1&supportsAttachments=true")
      .to_return(body: event_response.to_json)
  end

  def mock_event_update
    WebMock.stub(:patch, "https://www.googleapis.com/calendar/v3/calendars/primary/events/123456789?supportsAttachments=true&sendUpdates=None")
      .to_return(body: event_response.to_json)
  end

  def mock_event_delete
    WebMock.stub(:delete, "https://www.googleapis.com/calendar/v3/calendars/primary/events/123456789?sendUpdates=none&sendNotifications=false")
      .to_return(body: {"kind": "calendar#calendarDelete"}.to_json)
  end

  def mock_event_move
    WebMock.stub(:post, "https://www.googleapis.com/calendar/v3/calendars/original_calendar_id/events/event_id/move?destination=destination_calendar_id&sendUpdates=None")
      .to_return(body: event_response.to_json)
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
