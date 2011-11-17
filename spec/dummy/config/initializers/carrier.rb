Carrier.configure do |config|
  config.models.tables = {:message => "messages", :chain => "chains"}
  # config.ui.set :simple
  # config.routes.prefix_for_messages = "/inbox"
end
