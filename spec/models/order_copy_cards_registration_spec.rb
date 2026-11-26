# frozen_string_literal: true

require "rails_helper"

# OrderCopyCardsRegistration is created by the back office but may be encountered
# by the front office during GovPay webhook lookups.

RSpec.describe OrderCopyCardsRegistration do
  it "can be instantiated" do
    expect { described_class.new(reg_identifier: "CBDU789") }.not_to raise_error
  end

  it "is a TransientRegistration" do
    expect(described_class.new).to be_a(WasteCarriersEngine::TransientRegistration)
  end
end
