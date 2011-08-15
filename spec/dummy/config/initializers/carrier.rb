Carrier.configure do |config|
  config.models.tables = {:message => "messages", :chain => "chains"}
end
