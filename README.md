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

TODO: Write usage instructions here

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/red-ant/google/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
