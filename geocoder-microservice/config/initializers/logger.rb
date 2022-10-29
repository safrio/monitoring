# logdev = Application.environment == :production ? $stdout : Application.root.concat('/', Settings.logger.path)

logger = Ougai::Logger.new(
  $stdout,
  level: Settings.logger.level
)

# logger.formatter = Ougai::Formatters::Readable.new if ENV['RACK_ENV'] == 'development'

logger.before_log = lambda do |data|
  data[:service] = { name: Settings.app.name }
  data[:request_id] ||= Thread.current[:request_id]
end

Application.logger = logger
