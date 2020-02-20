[![Build Status](https://travis-ci.com/red-ant/google.svg?branch=master)](https://travis-ci.com/red-ant/google)

# google

Provides ability to interact with google services.

Currently supports following:

* OAuth Token Generation
  - By providing credentials via argument
  - By providing absolute path to `client_auth.json` file
* Directory API
  - List
  - Single user fetch
* Calendar
  - CalendarList
  - Listing calendar events
  - Single calendar event fetch
  - Create calendar event
  - Delete calendar event
  - Update calendar event
  - Move calendar event

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     google:
       github: red-ant/google
   ```

2. Run `shards install`

## Usage

```crystal
require "google"
```

### Auth comes in two flavors

#### Google::Auth

```crystal
Google::Auth.new(issuer: "test@example.com", signing_key: PRIVATE_KEY, scopes: "https://www.googleapis.com/auth/admin.directory.user.readonly", sub: "admin@example.com")
```

#### Google::FileAuth

```crystal
Google::FileAuth.new(file_path = "/absolute_path/client_auth.json", scopes: "https://www.googleapis.com/auth/admin.directory.user.readonly", sub: "admin@example.com")
```

### Directory

```crystal
# auth variable below can be instance of Google::Auth or Google::FileAuth
directory = Google::Directory.new(auth: auth, domain: "example.com")

# To fetch all users
directory.users

# Fetch single user
directory.lookup("test@example.com")
```

### Calendar
```crystal
# auth variable below can be instance of Google::Auth or Google::FileAuth
calendar = Google::Calendar.new(auth: auth)

# To fetch calendar list
calendar.calendar_list

# To fetch all calendar events
calendar.events

# To fetch single calendar event by id
calendar.event("event_id")

# To create calendar event
calendar.create(event_start: Time.utc, event_end: Time.utc + 1.hour, attendees: ["test@example.com"], summary: "ACA test event", description: "test description")

# To update single calendar event by id
calendar.update("event_id", summary: "updated summary")

# To delete single calendar event by id
calendar.delete("event")

# To move single calendar event by id
calendar.move(event_id: "event_id", calendar_id: "original_calendar_id", destination_id: "destination_calendar_id")
```

## Development

To run specs `crystal specs`

## Contributing

1. Fork it (<https://github.com/red-ant/google/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
