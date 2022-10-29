channel = RabbitMq.consumer_channel
exchange = channel.default_exchange
queue = channel.queue('ads', durable: true)

queue.subscribe(manual_ack: true) do |delivery_info, properties, payload|
  Thread.current[:request_id] = properties.headers['request_id']

  Application.logger.info('update_coordinates pure payload', payload: payload)

  payload = JSON(payload)

  Application.logger.info('update_coordinates payload', payload: payload)

  result = Ads::UpdateService.call(
    id: payload['id'],
    data: payload['coordinates']
  )

  Application.logger.info('update_coordinates result', result: result)
ensure
  # somewhy without this unacked message remained in geocoding queue :(
  exchange.publish('', routing_key: properties.reply_to, correlation_id: properties.correlation_id)

  channel.ack(delivery_info.delivery_tag)
end
