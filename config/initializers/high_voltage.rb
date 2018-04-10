# use page path on root , rather than /pages/XXX
HighVoltage.configure do |config|
  config.route_drawer = HighVoltage::RouteDrawers::Root
end
