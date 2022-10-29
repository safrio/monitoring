require 'benchmark'

channel = RabbitMq.consumer_channel
queue = channel.queue('geocoding', durable: true)

queue.subscribe(manual_ack: true) do |delivery_info, properties, payload|
  Thread.current[:request_id] = properties.headers['request_id']
  payload = JSON(payload)
  coordinates = nil

  Metrics.request_duration_seconds.observe(Benchmark.realtime do
    coordinates = Geocoder.geocode(payload['city'])
  end, labels: { action: 'geocode' })

  Application.logger.info(
    'geocoded coordinates',
    city: payload['city'],
    coordinates: coordinates
  )

  if coordinates.present?
    Metrics.geocoding_requests_total.increment(labels: { result: 'success' })
    client = AdsService::RpcClient.fetch
    client.update_coordinates(payload['id'], coordinates)
  else
    Metrics.geocoding_requests_total.increment(labels: { result: 'failure' })
  end
ensure
  channel.ack(delivery_info.delivery_tag)
end
