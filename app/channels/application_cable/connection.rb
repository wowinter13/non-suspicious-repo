module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :uuid

    def connect
      self.uuid = SecureRandom.uuid
      logger.add_tags 'ActionCable', uuid
    end

    def disconnect
      # https://github.com/rails/rails/pull/41673
      # There should be smth like: ActionCable.server.remote_connections.where(uuid: uuid).disconnect
      # But due to new syntax rules in Ruby 3.0 we have what we have :)
      # 1. Notify a user (graceful)
      # 2. Notify internal cables
      ActionCable.server.broadcast("sample_channel_#{uuid}", { type: 'disconnect' })
      ActionCable.server.broadcast("action_cable/#{uuid}", { type: 'disconnect' })
    end
  end
end
