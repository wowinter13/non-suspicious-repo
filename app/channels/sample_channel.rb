class SampleChannel < ApplicationCable::Channel
  def subscribed
    stream_from "sample_channel_#{uuid}"
  end

  def unsubscribed; end
end
