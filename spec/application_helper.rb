require 'spec_helper'

ENV['RACK_ENV'] ||= 'test'

require_relative '../config/environment'

abort(I18n.t(:test_in_production, scope: 'fatal.errors.red_alert')) if Application.environment == :production

Dir[Application.root.concat('/spec/support/**/*.rb')].sort.each { |f| require f }

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include RouteHelpers, type: :routes
end
