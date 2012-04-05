module CarrierRoutesHelper
  include Carrier::Engine.routes.url_helpers
end

World(CarrierRoutesHelper)
