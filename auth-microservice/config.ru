require_relative 'config/environment'

use Rack::Runtime
use Rack::Deflater
use Prometheus::Middleware::Collector
use Prometheus::Middleware::Exporter
use Rack::Ougai::LogRequests, Application.logger

run Rack::URLMap.new(
  '/v1/signup' => UserRoutes,
  '/v1/login' => UserSessionRoutes
)
