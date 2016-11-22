module SolidusProductFeed
  mattr_accessor :logger

  logger_destination =
    Rails.configuration.try(:product_feed_log_destination) || File.join(Rails.root, 'log', "#{Rails.env}.log")

  @@logger = Logger.new(logger_destination)
end
