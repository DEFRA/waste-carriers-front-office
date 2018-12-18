# frozen_string_literal: true

require "rails_helper"

RSpec.describe DashboardsHelper, type: :helper do
  let(:registration) { build(:registration) }

  describe "#url_to_view_certificate_for" do
    it "returns a temp value" do
      expect(helper.url_to_view_certificate_for(registration)).to eq("#")
    end
  end

  describe "#url_to_edit" do
    it "returns a temp value" do
      expect(helper.url_to_edit(registration)).to eq("#")
    end
  end

  describe "#url_to_renew" do
    it "returns a temp value" do
      expect(helper.url_to_renew(registration)).to eq("#")
    end
  end

  describe "#url_to_order_cards_for" do
    it "returns a temp value" do
      expect(helper.url_to_order_cards_for(registration)).to eq("#")
    end
  end

  describe "#url_to_delete" do
    it "returns a temp value" do
      expect(helper.url_to_delete(registration)).to eq("#")
    end
  end
end
