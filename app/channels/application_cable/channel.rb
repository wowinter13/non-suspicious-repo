module ApplicationCable
  class Channel < ActionCable::Channel::Base
    periodically :track_users, every: 5.seconds

    def track_users
      ActionCable.server.connections.each do |conn|
        order66 = Concurrent::TimerTask.new(execution_interval: 4) do
          conn.disconnect
          # After our user is notified, we could close the stream
          stop_stream_from "#{self.class.name.underscore}_#{conn.uuid}"
          # And close the connection
          conn.close(reconnect: false)
          # And finally remove the connection from Connection[]
          ActionCable.server.remove_connection(conn)
        end
        order66.execute
        # It ain't much, it's honest work.
        conn.instance_values['websocket'].instance_values['websocket'].instance_variable_get(:@driver).ping do
          order66.shutdown
        end
      end
      transmit({ 'title': 'users_online', 'message': ActionCable.server.connections.size })
    end
  end
end
