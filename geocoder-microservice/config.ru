require_relative 'config/environment'

use Rack::Deflater
use Prometheus::Middleware::Exporter

run proc() { [200, { 'Content-Type:' => 'text/html' }, ['OK']] }
