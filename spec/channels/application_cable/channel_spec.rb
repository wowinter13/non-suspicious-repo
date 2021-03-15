require "rails_helper"

RSpec.describe ApplicationCable::Channel, type: :connection do
  tests ApplicationCable::Connection

  let!(:fake_uuid) { SecureRandom.uuid }

  before do
    allow(SecureRandom).to receive(:uuid).and_return(fake_uuid)
    connect "/cable"
    # All this instance variables could be fixed with some refactoring of
    # ConnectionStub and ChannelStub in Rails.
    @connection.instance_variable_set(:@coder, ActiveSupport::JSON)
    @connection.instance_variable_set(
      :@websocket,
      ActionCable::Connection::WebSocket.new(
        @connection.instance_variable_get(:@env),
        @connection, ActionCable.server.event_loop
      )
    )
    @connection.instance_variable_get(:@websocket).instance_variable_set(
      :@websocket,
      ActionCable::Connection::ClientSocket.new(
        @connection.instance_variable_get(:@env),
        @connection, ActionCable.server.event_loop, ActionCable::INTERNAL[:protocols]
      )
    )
    ActionCable.server.add_connection(@connection)
  end

  after do
    ActionCable.server.connections.each { |c| ActionCable.server.remove_connection(c) }
  end

  describe '#track_users when device is online' do
    before { allow_any_instance_of(WebSocket::Driver::Draft75).to receive(:ping).and_return(true) }
      
    it 'broadcasts only 1 user' do
      channel = SampleChannel.new(@connection, "{uuid: #{fake_uuid}}")
      channel.track_users
      expect(ActionCable.server.connections.length).to eq 1
    end
  end

  describe '#track_users when device is offline' do
    before { allow_any_instance_of(WebSocket::Driver::Draft75).to receive(:ping).and_return(false) }
      
    it 'broadcasts only 0 user' do
      channel = SampleChannel.new(@connection, "{uuid: #{fake_uuid}}")
      channel.track_users
      sleep(10) # only used in spec to fully wait ping
      expect(ActionCable.server.connections.length).to eq 0
    end
  end
end