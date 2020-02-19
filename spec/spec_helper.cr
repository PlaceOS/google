require "json"
require "spec"
require "webmock"
require "../src/google"

Spec.before_each &->WebMock.reset
