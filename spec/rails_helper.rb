require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../config/environment', __dir__)

require "action_cable"

ActiveRecord::Migration.maintain_test_schema!

ActionCable.server.config.cable = { "adapter" => "test" }
ActionCable.server.config.logger =
  ActiveSupport::TaggedLogging.new ActiveSupport::Logger.new(StringIO.new)

Rails.application.eager_load!

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.include ActionCable::TestHelper
  config.include ActionCable::Channel::TestCase::Behavior, type: :channel
  config.include ActionCable::Channel::ChannelStub, type: :channel
  config.include ActionCable::Connection::TestCase::Behavior, type: :connection

  config.before(:each, type: %i(channel connection)) do
    ActionCable.server.connections.each { |c| ActionCable.server.remove_connection(c) }
  end
end