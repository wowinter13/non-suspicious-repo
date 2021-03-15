require "rails_helper"

RSpec.describe ActionCable::Connection, type: :connection do
  tests ApplicationCable::Connection

  let!(:fake_uuid) { SecureRandom.uuid }

  before do
    allow(SecureRandom).to receive(:uuid).and_return(fake_uuid)
  end

  describe '#connect' do
    it 'connects successfully' do
      connect "/cable"
      expect(connection.uuid).to eq fake_uuid
    end
  end

  describe '#disconnect' do
    before { connect "/cable" }

    it 'disconnects successfully' do
      expect_any_instance_of(ActionCable::Server::Base).to receive(:broadcast).with(
        "sample_channel_#{fake_uuid}", { type: 'disconnect' }
      )
      expect_any_instance_of(ActionCable::Server::Base).to receive(:broadcast).with(
        "action_cable/#{fake_uuid}", { type: 'disconnect' }
      )
      disconnect
    end
  end
end