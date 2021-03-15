require "rails_helper"

RSpec.describe SampleChannel, type: :channel do
  tests :sample_channel

  let!(:fake_uuid) { SecureRandom.uuid }

  before do
    allow(SecureRandom).to receive(:uuid).and_return(fake_uuid)
    stub_connection uuid: fake_uuid
  end

  it "subscribes to a sample channel" do
    subscribe
    expect(subscription).to be_confirmed
    expect(subscription.streams).to include("sample_channel_#{fake_uuid}")
  end
end