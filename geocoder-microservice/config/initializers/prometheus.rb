require 'prometheus/client'
require 'prometheus/middleware/exporter'

Metrics.configure do |registry|
  registry.counter(
    :geocoding_requests_total,
    docstring: 'The total number of geocoding requests',
    labels: %i[result]
  )

  registry.histogram(
    :request_duration_seconds,
    docstring: 'The request duration time in seconds',
    labels: %i[action]
  )
end
